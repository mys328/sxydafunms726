<%@page language="java" contentType="text/html;charset=gb2312" %>
<%@page import="com.afunms.detail.service.configInfo.NetmediaConfigInfoService"%>
<%@page import="com.afunms.detail.service.memoryInfo.MemoryInfoService"%>
<%@page import="com.jcraft.jsch.UserInfo"%>
<%@page import="com.afunms.temp.dao.UserTempDao"%>

<%@ include file="/include/globe.inc"%>
<%@ include file="/include/globeChinese.inc"%>


<%@page import="com.afunms.config.model.*"%>
<%@page import="com.afunms.config.dao.*"%>
<%@page import="com.afunms.topology.model.HostNode"%>
<%@page import="com.afunms.common.base.JspPage"%>
<%@page import="com.afunms.common.util.SysUtil"%>
<%@page import="com.afunms.common.util.*" %>
<%@page import="com.afunms.monitor.item.*"%>
<%@page import="com.afunms.polling.node.*"%>
<%@page import="com.afunms.polling.*"%>
<%@page import="com.afunms.polling.impl.*"%>
<%@page import="com.afunms.polling.api.*"%>
<%@page import="com.afunms.topology.util.NodeHelper"%>
<%@page import="com.afunms.topology.dao.*"%>
<%@page import="com.afunms.monitor.item.base.MoidConstants"%>
<%@page import="org.jfree.data.general.DefaultPieDataset"%>
<%@ page import="com.afunms.polling.api.I_Portconfig"%>
<%@ page import="com.afunms.polling.om.Portconfig"%>
<%@ page import="com.afunms.polling.om.*"%>
<%@ page import="com.afunms.polling.impl.PortconfigManager"%>
<%@page import="com.afunms.report.jfree.ChartCreator"%>
<%@ page import="com.afunms.config.model.*"%>
<%@ page import="com.afunms.event.model.EventList"%>
<%@page import="com.afunms.detail.service.cpuInfo.CpuInfoService"%>
<%@page import="com.afunms.detail.service.diskInfo.DiskInfoService"%>
<%@page import="com.afunms.detail.service.OtherInfo.OtherInfoService"%>
<%@page import="com.afunms.detail.service.systemInfo.SystemInfoService"%>
<%@page import="com.afunms.detail.service.interfaceInfo.InterfaceInfoService"%>
<%@page import="com.afunms.indicators.model.NodeDTO"%>
<%@page import="com.afunms.indicators.util.NodeUtil"%>


<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.*"%>
<%@page import="com.afunms.monitor.item.base.*"%>
<%@page import="com.afunms.monitor.executor.base.*"%>
<%@ page import="org.apache.commons.beanutils.BeanUtils"%>
<%
	String runmodel = PollingEngine.getCollectwebflag(); 
	String rootPath = request.getContextPath();
  	String menuTable = (String)request.getAttribute("menuTable");
	String[] processItem={"pid","Name","Type","CpuTime","MemoryUtilization","Memory","Status"};
	String[] processItemch={"进程ID","进程名称","进程类型","cpu时间","内存占用率","内存占用量","当前状态"};
	String[] pingItem={"ResponseTime","LostPack"}; 
	Hashtable userhash = (Hashtable)request.getAttribute("userhash");
	Hashtable processhash = (Hashtable) request.getAttribute("processhash"); 
	List cpuconfiglist = new ArrayList();
	List netmedialist = new ArrayList();
	
	
	Hashtable max = (Hashtable) request.getAttribute("max");
	Hashtable memmaxhash = (Hashtable) request.getAttribute("memmaxhash");
	Hashtable memavghash = (Hashtable) request.getAttribute("memavghash");
	Hashtable diskhash = (Hashtable) request.getAttribute("diskhash");
	Hashtable memhash = (Hashtable) request.getAttribute("memhash");
	
	String avgcpu = (String)max.get("cpuavg");
	String cpumax = (String)max.get("cpu");
  	String tmp = request.getParameter("id"); 
	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	double cpuvalue = 0;
	String pingconavg ="0";
	String collecttime = null;
	String sysuptime = null;
	String sysservices = null;
	String sysdescr = null;
	
	String hostname = "";
	String porcessors = "";
	String sysname = "";
	String SerialNumber = "";
	String CSDVersion = "";
	String mac = "";
	
	Hashtable pagehash = new Hashtable();
	Hashtable paginghash = new Hashtable();
	int pageingused = 0;
	String totalpageing = "";
	Hashtable hostinfohash = new Hashtable();
    List networkconfiglist = new ArrayList();
    List cpulist = new ArrayList();
    Nodeconfig nodeconfig = new Nodeconfig();
    Vector memoryVector = new Vector();
    Vector userVector = new Vector();
    String processornum = "";
    String TotalVisibleMemorySize = "";
    String TotalSwapMemorySize = "";
    Supper supper = null;
    String suppername = "";
    int percent1 = 0;
    int percent2 = 0;
    int cpuper = 0;
		
	Host host = new Host();
	host = (Host)PollingEngine.getInstance().getNodeByID(Integer.parseInt(tmp));
   	if("0".equals(runmodel)){
       	//采集与访问是集成模式
    	String ipaddress = host.getIpAddress();
    	String orderflag = request.getParameter("orderflag");
    	if(orderflag == null || orderflag.trim().length()==0)
    		orderflag="index";
        String[] time = {"",""};
        DateE datemanager = new DateE();
        Calendar current = new GregorianCalendar();
        current.set(Calendar.MINUTE,59);
        current.set(Calendar.SECOND,59);
        time[1] = datemanager.getDateDetail(current);
        current.add(Calendar.HOUR_OF_DAY,-1);
        current.set(Calendar.MINUTE,0);
        current.set(Calendar.SECOND,0);
        time[0] = datemanager.getDateDetail(current);
        String starttime = time[0];
        String endtime = time[1];
        
        I_HostLastCollectData hostlastmanager=new HostLastCollectDataManager();
        
        Vector vector = new Vector();
        String[] netInterfaceItem={"index","ifDescr","ifSpeed","ifOperStatus","OutBandwidthUtilHdx","InBandwidthUtilHdx"};
        try{
        	vector = hostlastmanager.getInterface_share(host.getIpAddress(),netInterfaceItem,orderflag,starttime,endtime); 
        }catch(Exception e){
        	e.printStackTrace();
        }
		Hashtable ipAllData = (Hashtable)ShareData.getSharedata().get(host.getIpAddress());
		if(ipAllData != null){
			nodeconfig= (Nodeconfig)ipAllData.get("nodeconfig");
			if(nodeconfig != null){
				mac = nodeconfig.getMac();
				processornum = nodeconfig.getNumberOfProcessors();
				CSDVersion = nodeconfig.getCSDVersion();
				hostname = nodeconfig.getHostname();
			}
			cpuconfiglist = (List)ipAllData.get("cpuconfiglist");
			
			netmedialist = (List)ipAllData.get("netmedialist");
			
			userVector = (Vector)ipAllData.get("user");
			
			memoryVector = (Vector)ipAllData.get("memory");
			if(memoryVector != null && memoryVector.size()>0){
				for(int i=0;i<memoryVector.size();i++){
					Memorycollectdata memorydata = (Memorycollectdata)memoryVector.get(i);
					if(memorydata.getSubentity().equalsIgnoreCase("PhysicalMemory") && memorydata.getEntity().equalsIgnoreCase("Capability"))
						TotalVisibleMemorySize = memorydata.getThevalue()+memorydata.getUnit();
					if(memorydata.getSubentity().equalsIgnoreCase("SwapMemory") && memorydata.getEntity().equalsIgnoreCase("Capability"))
						TotalSwapMemorySize = memorydata.getThevalue()+memorydata.getUnit();
				}
			}
			Vector cpuV = (Vector)ipAllData.get("cpu");
			if(cpuV != null && cpuV.size()>0){
				CPUcollectdata cpu = (CPUcollectdata)cpuV.get(0);
				if(cpu != null && cpu.getThevalue() != null){
					cpuvalue = new Double(cpu.getThevalue());
				}
			}
			//得到数据采集时间
			collecttime = (String)ipAllData.get("collecttime");
			
			pagehash = (Hashtable)ipAllData.get("pagehash");
			
			paginghash = (Hashtable)ipAllData.get("paginghash");
			if(paginghash == null)paginghash = new Hashtable();
			if(paginghash.get("Total_Paging_Space") != null){
				pageingused = Integer.parseInt(((String)paginghash.get("Percent_Used")).replaceAll("%",""));
				totalpageing = (String)paginghash.get("Total_Paging_Space");
			}
			//得到系统启动时间
			Vector systemV = (Vector)ipAllData.get("system");
			if(systemV != null && systemV.size()>0){
				for(int i=0;i<systemV.size();i++){
					Systemcollectdata systemdata=(Systemcollectdata)systemV.get(i);
					if(systemdata.getSubentity().equalsIgnoreCase("sysUpTime")){
						sysuptime = systemdata.getThevalue();
					}
					if(systemdata.getSubentity().equalsIgnoreCase("sysServices")){
						sysservices = systemdata.getThevalue();
					}
					if(systemdata.getSubentity().equalsIgnoreCase("sysDescr")){
						sysdescr = systemdata.getThevalue();
					}
					if(systemdata.getSubentity().equalsIgnoreCase("SysName")){
						sysname = systemdata.getThevalue();
					}
				}
			}
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String time1 = sdf.format(new Date());
		String starttime1 = time1 + " 00:00:00";
		String totime1 = time1 + " 23:59:59";
			
		Hashtable ConnectUtilizationhash = new Hashtable();
		I_HostCollectData hostmanager=new HostCollectDataManager();
		try{
			ConnectUtilizationhash = hostmanager.getCategory(host.getIpAddress(),"Ping","ConnectUtilization",starttime1,totime1);
		}catch(Exception ex){
			ex.printStackTrace();
		}
			
		if (ConnectUtilizationhash.get("avgpingcon")!=null){
			pingconavg = (String)ConnectUtilizationhash.get("avgpingcon");
			pingconavg = pingconavg.replace("%", "");
		}
		
        request.setAttribute("vector", vector);
        request.setAttribute("id", tmp);
        request.setAttribute("ipaddress", host.getIpAddress());
		request.setAttribute("cpuvalue", cpuvalue);
		request.setAttribute("collecttime", collecttime);
		request.setAttribute("sysuptime", sysuptime);
		request.setAttribute("sysservices", sysservices);
		request.setAttribute("sysdescr", sysdescr);
		request.setAttribute("pingconavg", new Double(pingconavg));
	
		String[] sysItem={"sysName","sysUpTime","sysContact","sysLocation","sysServices","sysDescr"};
		String[] sysItemch={"设备名","设备启动时间","设备联系","设备位置","设备服务","设备描述"};
	
		Hashtable hash = (Hashtable)request.getAttribute("hash");
		Hashtable hash1 = (Hashtable)request.getAttribute("hash1");
		Hashtable imgurl = (Hashtable)request.getAttribute("imgurl");
	
		double avgpingcon = (Double)request.getAttribute("pingconavg");
	
		percent1 = Double.valueOf(avgpingcon).intValue();
		percent2 = 100-percent1;
		
		cpuper = Double.valueOf(cpuvalue).intValue();
		
	  	//String rootPath = request.getContextPath(); 
	  
		Vector ipmacvector = (Vector)request.getAttribute("vector");
		if (ipmacvector == null)ipmacvector = new Vector();  
	  
	  	//ResponseTimeItem item1 = (ResponseTimeItem)host.getMoidList().get(0); 
	  	String chart1 = null,chart2 = null,chart3 = null,responseTime = null;
	  	DefaultPieDataset dpd = new DefaultPieDataset();
	  	dpd.setValue("可用率",avgpingcon);
	  	dpd.setValue("不可用率",100 - avgpingcon);
	  	chart1 = ChartCreator.createPieChart(dpd,"",130,130);  
  
  	//if(item1.getSingleResult()!=-1)
  	//{
     	//responseTime = item1.getSingleResult() + " ms";
  
     	//SnmpItem item2 = (SnmpItem)host.getItemByMoid(MoidConstants.CISCO_CPU);
     	//if(item2!=null&&item2.getSingleResult()!=-1)
      	//chart2 = ChartCreator.createMeterChart(item2.getSingleResult(),"",150,150); 
       	chart2 = ChartCreator.createMeterChart(cpuvalue,"",120,120);   
  
     	//SnmpItem item3 = (SnmpItem)host.getItemByMoid(MoidConstants.CISCO_MEMORY);
     	//if(item3!=null&&item3.getSingleResult()!=-1)
        chart3 = ChartCreator.createMeterChart(40.0,"",120,120);       
  	//}
 	//else
     	//responseTime = "无响应"; 
     
     	Vector ifvector = (Vector)request.getAttribute("vector"); 	
        String startdate = (String)request.getAttribute("startdate");
		String todate = (String)request.getAttribute("todate");	
      	SupperDao supperdao = new SupperDao();
    	try{
    		supper = (Supper)supperdao.findByID(host.getSupperid()+"");
    		if(supper != null)suppername = supper.getSu_name()+"("+supper.getSu_dept()+")";
    	}catch(Exception e){
    		e.printStackTrace();
    	}finally{
    		supperdao.close();
    	} 
    }else{
	    //采集与访问是分离模式
    	NodeUtil nodeUtil = new NodeUtil();
        NodeDTO nodedto = nodeUtil.creatNodeDTOByNode(host); 
    	String ipaddress = host.getIpAddress();
    	String orderflag = request.getParameter("orderflag");
    	if(orderflag == null || orderflag.trim().length()==0)
    		orderflag="index";
        String[] time = {"",""};
        DateE datemanager = new DateE();
        Calendar current = new GregorianCalendar();
        current.set(Calendar.MINUTE,59);
        current.set(Calendar.SECOND,59);
        time[1] = datemanager.getDateDetail(current);
        current.add(Calendar.HOUR_OF_DAY,-1);
        current.set(Calendar.MINUTE,0);
        current.set(Calendar.SECOND,0);
        time[0] = datemanager.getDateDetail(current);
        String starttime = time[0];
        String endtime = time[1];
        
        I_HostLastCollectData hostlastmanager=new HostLastCollectDataManager();
          
        //InterfaceInfoService interfaceInfoService = new InterfaceInfoService(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype());
		//Vector vector = new Vector();
		//String[] netInterfaceItem={"index","ifDescr","ifSpeed","ifOperStatus","OutBandwidthUtilHdx","InBandwidthUtilHdx"};
		//try{
		//	vector = interfaceInfoService.getInterfaceInfo(netInterfaceItem); 
		//}catch(Exception e){
		//	e.printStackTrace();
		//}
		//Hashtable ipAllData = (Hashtable)ShareData.getSharedata().get(host.getIpAddress());
		//if(ipAllData != null){
			//nodeconfig= (Nodeconfig)ipAllData.get("nodeconfig");
			NodeconfigDao nodeconfigDao = new NodeconfigDao();
			try{
				nodeconfig = nodeconfigDao.getByNodeID(nodedto.getId()+"");
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				nodeconfigDao.close();
			}
			if(nodeconfig != null){
				mac = nodeconfig.getMac();
				processornum = nodeconfig.getNumberOfProcessors();
				CSDVersion = nodeconfig.getCSDVersion();
				hostname = nodeconfig.getHostname();
			}
			//CpuconfigDao cpuconfigDao = new CpuconfigDao();  
			NodecpuconfigDao cpucoNodecpuconfigDao = new NodecpuconfigDao();
			try{
				cpuconfiglist = cpucoNodecpuconfigDao.getNodecpuconfig(nodedto.getId()+"");
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				cpucoNodecpuconfigDao.close();
			}
			//cpuconfiglist = (List)ipAllData.get("cpuconfiglist");
			
			NetmediaConfigInfoService netmediaConfigInfoService = new NetmediaConfigInfoService(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype());
			//netmedialist = (List)ipAllData.get("netmedialist");
			netmedialist = netmediaConfigInfoService.getNetmediaConfigInfo(); 
			
			//userVector = (Vector)ipAllData.get("user");  
			UserTempDao userTempDao = new UserTempDao();
			try{
				userVector = userTempDao.getUserInfo(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype());
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				userTempDao.close();
			}
			MemoryInfoService memoryInfoService = new MemoryInfoService(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype());
			memoryVector = memoryInfoService.getMemoryInfo();
			//memoryVector = (Vector)ipAllData.get("memory");
			if(memoryVector != null && memoryVector.size()>0){
				for(int i=0;i<memoryVector.size();i++){
					Memorycollectdata memorydata = (Memorycollectdata)memoryVector.get(i);
					if(memorydata.getSubentity().equalsIgnoreCase("PhysicalMemory") && memorydata.getEntity().equalsIgnoreCase("Capability"))
						TotalVisibleMemorySize = memorydata.getThevalue()+memorydata.getUnit();
					if(memorydata.getSubentity().equalsIgnoreCase("SwapMemory") && memorydata.getEntity().equalsIgnoreCase("Capability"))
						TotalSwapMemorySize = memorydata.getThevalue()+memorydata.getUnit();
				}
			}
			//Vector cpuV = (Vector)ipAllData.get("cpu");
			CpuInfoService cpuInfoService = new CpuInfoService(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype()); 
			Vector cpuV = cpuInfoService.getCpuInfo(); 
			if(cpuV != null && cpuV.size()>0){
				CPUcollectdata cpu = (CPUcollectdata)cpuV.get(0);
				if(cpu != null && cpu.getThevalue() != null){
					cpuvalue = new Double(cpu.getThevalue());
				}
			}
			
			//得到数据采集时间
			//collecttime = (String)ipAllData.get("collecttime");
			
			//pagehash = (Hashtable)ipAllData.get("pagehash");
			
			OtherInfoService otherInfoService = new OtherInfoService(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype());
			collecttime = otherInfoService.getCollecttime();
			paginghash = otherInfoService.getPaginghash();
			pagehash = otherInfoService.getPagehash();
			//paginghash = (Hashtable)ipAllData.get("paginghash"); 
			if(paginghash == null)paginghash = new Hashtable();
			if(paginghash.get("Total_Paging_Space") != null){
				pageingused = Integer.parseInt(((String)paginghash.get("Percent_Used")).replaceAll("%",""));
				totalpageing = (String)paginghash.get("Total_Paging_Space");
			}
			//得到系统启动时间  
			//Vector systemV = (Vector)ipAllData.get("system");
			SystemInfoService systemInfoService = new SystemInfoService(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype()); 
			Vector systemV = systemInfoService.getSystemInfo();
			if(systemV != null && systemV.size()>0){ 
				for(int i=0;i<systemV.size();i++){
					Systemcollectdata systemdata=(Systemcollectdata)systemV.get(i);
					if(systemdata.getSubentity().equalsIgnoreCase("sysUpTime")){
						sysuptime = systemdata.getThevalue();
					}
					if(systemdata.getSubentity().equalsIgnoreCase("sysServices")){
						sysservices = systemdata.getThevalue();
					}
					if(systemdata.getSubentity().equalsIgnoreCase("sysDescr")){
						sysdescr = systemdata.getThevalue();
					}
					if(systemdata.getSubentity().equalsIgnoreCase("SysName")){
						sysname = systemdata.getThevalue();
					}
				}
			}
		//}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String time1 = sdf.format(new Date());
		String starttime1 = time1 + " 00:00:00";
		String totime1 = time1 + " 23:59:59";
			
		Hashtable ConnectUtilizationhash = new Hashtable();
		I_HostCollectData hostmanager=new HostCollectDataManager();
		try{
			ConnectUtilizationhash = hostmanager.getCategory(host.getIpAddress(),"Ping","ConnectUtilization",starttime1,totime1);
		}catch(Exception ex){
			ex.printStackTrace();
		}
			
		if (ConnectUtilizationhash.get("avgpingcon")!=null){
			pingconavg = (String)ConnectUtilizationhash.get("avgpingcon");
			pingconavg = pingconavg.replace("%", "");
		}
		
        //request.setAttribute("vector", vector);
        request.setAttribute("id", tmp);
        request.setAttribute("ipaddress", host.getIpAddress());
		request.setAttribute("cpuvalue", cpuvalue);
		request.setAttribute("collecttime", collecttime);
		request.setAttribute("sysuptime", sysuptime);
		request.setAttribute("sysservices", sysservices);
		request.setAttribute("sysdescr", sysdescr);
		request.setAttribute("pingconavg", new Double(pingconavg));
	
		String[] sysItem={"sysName","sysUpTime","sysContact","sysLocation","sysServices","sysDescr"};
		String[] sysItemch={"设备名","设备启动时间","设备联系","设备位置","设备服务","设备描述"};
	
		Hashtable hash = (Hashtable)request.getAttribute("hash");
		Hashtable hash1 = (Hashtable)request.getAttribute("hash1");
		Hashtable imgurl = (Hashtable)request.getAttribute("imgurl");
	
		double avgpingcon = (Double)request.getAttribute("pingconavg");
	
		percent1 = Double.valueOf(avgpingcon).intValue();
		percent2 = 100-percent1;
		
		cpuper = Double.valueOf(cpuvalue).intValue();
		
	  	//String rootPath = request.getContextPath(); 
	  
		Vector ipmacvector = (Vector)request.getAttribute("vector");
		if (ipmacvector == null)ipmacvector = new Vector();  
	  
	  	//ResponseTimeItem item1 = (ResponseTimeItem)host.getMoidList().get(0); 
	  	String chart1 = null,chart2 = null,chart3 = null,responseTime = null;
	  	DefaultPieDataset dpd = new DefaultPieDataset();
	  	dpd.setValue("可用率",avgpingcon);
	  	dpd.setValue("不可用率",100 - avgpingcon);
	  	chart1 = ChartCreator.createPieChart(dpd,"",130,130);  
  
  	//if(item1.getSingleResult()!=-1)
  	//{
     	//responseTime = item1.getSingleResult() + " ms";
  
     	//SnmpItem item2 = (SnmpItem)host.getItemByMoid(MoidConstants.CISCO_CPU);
     	//if(item2!=null&&item2.getSingleResult()!=-1)
      	//chart2 = ChartCreator.createMeterChart(item2.getSingleResult(),"",150,150); 
       	chart2 = ChartCreator.createMeterChart(cpuvalue,"",120,120);   
  
     	//SnmpItem item3 = (SnmpItem)host.getItemByMoid(MoidConstants.CISCO_MEMORY);
     	//if(item3!=null&&item3.getSingleResult()!=-1)
        chart3 = ChartCreator.createMeterChart(40.0,"",120,120);       
  	//}
 	//else
     	//responseTime = "无响应"; 
     
     	Vector ifvector = (Vector)request.getAttribute("vector"); 	
        String startdate = (String)request.getAttribute("startdate");
		String todate = (String)request.getAttribute("todate");	
      	SupperDao supperdao = new SupperDao();
    	try{
    		supper = (Supper)supperdao.findByID(host.getSupperid()+"");
    		if(supper != null)suppername = supper.getSu_name()+"("+supper.getSu_dept()+")";
    	}catch(Exception e){
    		e.printStackTrace();
    	}finally{
    		supperdao.close();
    	} 
	}
	double avgpingcon = new Double(pingconavg);
	String ip = host.getIpAddress();
	String picip = CommonUtil.doip(ip);
    	//生成当天平均连通率图形
		CreatePiePicture _cpp = new CreatePiePicture();
	        TitleModel _titleModel = new TitleModel();
	        _titleModel.setXpic(150);
	        _titleModel.setYpic(150);//160, 200, 150, 100
	        _titleModel.setX1(75);//外环向左的位置
	        _titleModel.setX2(60);//外环向上的位置
	        _titleModel.setX3(65);
	        _titleModel.setX4(30);
	        _titleModel.setX5(75);
	        _titleModel.setX6(70);
	        _titleModel.setX7(10);
	        _titleModel.setX8(115);
	        _titleModel.setBgcolor(0xffffff);
	        _titleModel.setPictype("png");
	        _titleModel.setPicName(picip+"pingavg");
	        _titleModel.setTopTitle("");
	        
	        double[] _data1 = {avgpingcon, 100-avgpingcon};
	        //double[] _data2 = {77, 87};
	        String[] p_labels = {"连通", "未连通"};
	        int[] _colors = {0x66ff66, 0xff0000}; 
	        String _title1="第一季度";
	        String _title2="第二季度";
	        _cpp.createOneRingChart(_data1,p_labels,_colors,_titleModel);
	        
	   //生成CPU仪表盘
		CreateMetersPic cmp = new CreateMetersPic();
		cmp.createCpuPic(picip, cpuper); //生成CPU仪表盘
		  	   
%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>
<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>

<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css"/>


<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 
<link rel="stylesheet" type="text/css" 	href="<%=rootPath%>/js/ext/lib/resources/css/ext-all.css" charset="utf-8" />
<link rel="stylesheet" type="text/css" href="<%=rootPath%>/js/ext/css/common.css" charset="utf-8"/>
<script type="text/javascript" 	src="<%=rootPath%>/js/ext/lib/adapter/ext/ext-base.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/ext-all.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/locale/ext-lang-zh_CN.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/resource/js/jquery-1.4.2.min.js"></script>
<script>
function createQueryString(){
		var user_name = encodeURI($("#user_name").val());
		var passwd = encodeURI($("#passwd").val());
		var queryString = {userName:user_name,passwd:passwd};
		return queryString;
	}
function gzmajax(){
$.ajax({
			type:"GET",
			dataType:"json",
			url:"<%=rootPath%>/serverAjaxManager.ajax?action=ajaxUpdate_availability&tmp=<%=tmp%>&nowtime="+(new Date()),
			success:function(data){
				 $("#pingavg").attr({ src: "<%=rootPath%>/resource/image/jfreechart/reportimg/<%=picip%>pingavg.png?nowtime="+(new Date()), alt: "平均连通率" });
				$("#cpu").attr({ src: "<%=rootPath%>/resource/image/jfreechart/reportimg/<%=picip%>cpu.png?nowtime="+(new Date()), alt: "当前CPU利用率" }); 
			
			}
		});
}
$(document).ready(function(){
	//$("#testbtn").bind("click",function(){
	//	gzmajax();
	//});
setInterval(gzmajax,60000);
});
</script>

<script language="javascript">	
  
  Ext.onReady(function()
{  

setTimeout(function(){
	        Ext.get('loading').remove();
	        Ext.get('loading-mask').fadeOut({remove:true});
	    }, 250);
	
	
	
});

  function doQuery()
  {  
     if(mainForm.key.value=="")
     {
     	alert("请输入查询条件");
     	return false;
     }
     mainForm.action = "<%=rootPath%>/network.do?action=find";
     mainForm.submit();
  }
  
    function toGetConfigFile()
  {
        msg.style.display="block";
        mainForm.action = "<%=rootPath%>/cfgfile.do?action=getcfgfile&ipaddress=<%=host.getIpAddress()%>";
        mainForm.submit();
  }
  
  function doChange()
  {
     if(mainForm.view_type.value==1)
        window.location = "<%=rootPath%>/topology/network/index.jsp";
     else
        window.location = "<%=rootPath%>/topology/network/port.jsp";
  }

  function toAdd()
  {
      mainForm.action = "<%=rootPath%>/network.do?action=ready_add";
      mainForm.submit();
  }
  
function changeOrder(para){
  	location.href="<%=rootPath%>/detail/host_linuxutilhdx.jsp?id=<%=tmp%>&ipaddress=<%=host.getIpAddress()%>&orderflag="+para;
} 
function openwin3(operate,index,ifname) 
{	
        window.open ("<%=rootPath%>/monitor.do?action="+operate+"&id=<%=tmp%>&ipaddress=<%=host.getIpAddress()%>&ifindex="+index+"&ifname="+ifname, "newwindow", "height=500, width=600, toolbar= no, menubar=no, scrollbars=yes, resizable=yes, location=yes, status=yes") 
} 

function reportByMinute(){
	window.open("<%=rootPath%>/monitor.do?action=hostping_report&id=<%=tmp%>&timeType=minute","newWindow","height=300, width=800, top=0, left= 200,screenX=0,screenY=0");
  }
  
  function query()
  {  
  	mainForm.id.value = <%=tmp%>;
     mainForm.action = "<%=rootPath%>/monitor.do?action=hostevent";
     mainForm.submit();
  }
  
// 全屏观看
function gotoFullScreen() {
	parent.mainFrame.resetProcDlg();
	var status = "toolbar=no,height="+ window.screen.height + ",";
	status += "width=" + (window.screen.width-8) + ",scrollbars=no";
	status += "screenX=0,screenY=0";
	window.open("topology/network/index.jsp", "fullScreenWindow", status);
	parent.mainFrame.zoomProcDlg("out");
}

</script>
<script language="JavaScript">

	//公共变量
	var node="";
	var ipaddress="";
	var operate="";
	/**
	*根据传入的id显示右键菜单
	*/
	function showMenu(id,nodeid,ip)
	{	
		ipaddress=ip;
		node=nodeid;
		//operate=oper;
	    if("" == id)
	    {
	        popMenu(itemMenu,100,"100");
	    }
	    else
	    {
	        popMenu(itemMenu,100,"1111");
	    }
	    event.returnValue=false;
	    event.cancelBubble=true;
	    return false;
	}
	/**
	*显示弹出菜单
	*menuDiv:右键菜单的内容
	*width:行显示的宽度
	*rowControlString:行控制字符串，0表示不显示，1表示显示，如“101”，则表示第1、3行显示，第2行不显示
	*/
	function popMenu(menuDiv,width,rowControlString)
	{
	    //创建弹出菜单
	    var pop=window.createPopup();
	    //设置弹出菜单的内容
	    pop.document.body.innerHTML=menuDiv.innerHTML;
	    var rowObjs=pop.document.body.all[0].rows;
	    //获得弹出菜单的行数
	    var rowCount=rowObjs.length;
	    //alert("rowCount==>"+rowCount+",rowControlString==>"+rowControlString);
	    //循环设置每行的属性
	    for(var i=0;i<rowObjs.length;i++)
	    {
	        //如果设置该行不显示，则行数减一
	        var hide=rowControlString.charAt(i)!='1';
	        if(hide){
	            rowCount--;
	        }
	        //设置是否显示该行
	        rowObjs[i].style.display=(hide)?"none":"";
	        //设置鼠标滑入该行时的效果
	        rowObjs[i].cells[0].onmouseover=function()
	        {
	            this.style.background="#397DBD";
	            this.style.color="white";
	        }
	        //设置鼠标滑出该行时的效果
	        rowObjs[i].cells[0].onmouseout=function(){
	            this.style.background="#F1F1F1";
	            this.style.color="black";
	        }
	    }
	    //屏蔽菜单的菜单
	    pop.document.oncontextmenu=function()
	    {
	            return false; 
	    }
	    //选择右键菜单的一项后，菜单隐藏
	    pop.document.onclick=function()
	    {
	        pop.hide();
	    }
	    //显示菜单
	    pop.show(event.clientX-1,event.clientY,width,rowCount*25,document.body);
	    return true;
	}
	function detail()
	{
	    //location.href="<%=rootPath%>/detail/dispatcher.jsp?id="+node;
	    window.open ("<%=rootPath%>/monitor.do?action=show_hostutilhdx&id=<%=tmp%>&ipaddress=<%=host.getIpAddress()%>&ifindex="+node+"&ifname="+ipaddress, "newwindow", "height=500, width=600, toolbar= no, menubar=no, scrollbars=yes, resizable=yes, location=yes, status=yes");
	}
	function portset()
	{
		window.open ("<%=rootPath%>/panel.do?action=show_portreset&ipaddress=<%=host.getIpAddress()%>&ifindex="+node, "newwindow", "height=200, width=600, toolbar= no, menubar=no, scrollbars=yes, resizable=yes, location=yes, status=yes");
	}	
</script>

<script language="JavaScript" type="text/JavaScript">
var show = true;
var hide = false;
//修改菜单的上下箭头符号
function my_on(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="on";
}
function my_off(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="off";
}
//添加菜单	
function initmenu()
{
	var idpattern=new RegExp("^menu");
	var menupattern=new RegExp("child$");
	var tds = document.getElementsByTagName("div");
	for(var i=0,j=tds.length;i<j;i++){
		var td = tds[i];
		if(idpattern.test(td.id)&&!menupattern.test(td.id)){					
			menu =new Menu(td.id,td.id+"child",'dtu','100',show,my_on,my_off);
			menu.init();		
		}
	}
	setClass();
}

function setClass(){
	document.getElementById('aixDetailTitle-3').className='detail-data-title';
	document.getElementById('aixDetailTitle-3').onmouseover="this.className='detail-data-title'";
	document.getElementById('aixDetailTitle-3').onmouseout="this.className='detail-data-title'";
}

function refer(action){
		document.getElementById("id").value="<%=tmp%>";
		var mainForm = document.getElementById("mainForm");
		mainForm.action = '<%=rootPath%>' + action;
		mainForm.submit();
}

//网络设备的ip地址
function modifyIpAliasajax(ipaddress){
	var t = document.getElementById('ipalias'+ipaddress);
	var ipalias = t.options[t.selectedIndex].text;//获取下拉框的值
	$.ajax({
			type:"GET",
			dataType:"json",
			url:"<%=rootPath%>/networkDeviceAjaxManager.ajax?action=modifyIpAlias&ipaddress="+ipaddress+"&ipalias="+ipalias,
			success:function(data){
				window.alert("修改成功！");
			}
		});
}
$(document).ready(function(){
	//$("#testbtn").bind("click",function(){
	//	gzmajax();
	//});
//setInterval(modifyIpAliasajax,60000);
});
</script>

</head>
	<body id="body" class="body" onload="initmenu();">
		<div id="itemMenu" style="display: none";>
			<table border="1" width="100%" height="100%" bgcolor="#F1F1F1"
				style="border: thin; font-size: 12px" cellspacing="0">
				<tr>
					<td style="cursor: default; border: outset 1;" align="center"
						onclick="parent.detail()">
						查看状态
					</td>
				</tr>
				<tr>
					<td style="cursor: default; border: outset 1;" align="center"
						onclick="parent.portset();">
						端口设置
					</td>
				</tr>
			</table>
		</div>

		<form id="mainForm" method="post" name="mainForm">
			<input type=hidden name="orderflag">
			<input type=hidden name="id">

			<table id="body-container" class="body-container">
				<tr>
					<td class="td-container-menu-bar">
						<table id="container-menu-bar" class="container-menu-bar">
							<tr>
								<td>
									<%=menuTable%>
								</td>
							</tr>
						</table>
					</td>
					<td class="td-container-main">
						<table id="container-main" class="container-main">
							<tr>
								<td class="td-container-main-detail" width=85%>
									<table id="container-main-detail" class="container-main-detail">
										<tr>
											<td>
												<jsp:include page="/topology/includejsp/systeminfo_hostaix.jsp">
													<jsp:param name="rootPath" value="<%=rootPath%>" />
													<jsp:param name="tmp" value="<%=tmp%>" />
													<jsp:param name="picip" value="<%=picip%>" />
													<jsp:param name="hostname" value="<%=hostname%>" />
													<jsp:param name="sysname" value="<%=sysname%>" />
													<jsp:param name="CSDVersion" value="<%=CSDVersion%>" />
													<jsp:param name="processornum" value="<%=processornum%>" />
													<jsp:param name="collecttime" value="<%=collecttime%>" />
													<jsp:param name="sysuptime" value="<%=sysuptime%>" />
													<jsp:param name="mac" value="<%=mac%>" />
													<jsp:param name="pageingused" value="<%=pageingused%>" />
													<jsp:param name="totalpageing" value="<%=totalpageing%>" />
												</jsp:include>
											</td>
										</tr>
										<tr>
											<td>
												<table id="detail-data" class="detail-data">
													<tr>
														<td class="detail-data-header">
															<%=aixDetailTitleTable%>
														</td>
													</tr>
													<tr>
														<td>
															<table class="detail-data-body">
																<tr>
																	<td align=center>
																		<table width="100%" border="0" cellpadding="0"
																			cellspacing="1">
																			<tr>
																				<td align=center>
																					<table width="80%" border="0" cellpadding="0"
																						cellspacing="1" bgcolor="#ECECEC">
																						<tr>
																							<td height="28" align="left" bgcolor="#ECECEC"
																								colspan=5>
																								&nbsp;&nbsp;
																								<b>CPU配置信息</b>
																							</td>
																						</tr>
																						<tr align="center" bgcolor="#ECECEC" height=28>
																							<td width="10%" class="detail-data-body-title"
																								align="center">
																								数据位
																							</td>
																							<td width="20%" class="detail-data-body-title"
																								align="center">
																								处理器ID
																							</td>
																							<td width="40%" class="detail-data-body-title"
																								align="center">
																								名称
																							</td>
																							<td width="15%" class="detail-data-body-title"
																								align="center">
																								CPU型号
																							</td>
																							<td width="15%" class="detail-data-body-title"
																								align="center">
																								主频
																							</td>
																						</tr>

																						<%
																							if (cpuconfiglist != null && cpuconfiglist.size() > 0) {
																								for (int i = 0; i < cpuconfiglist.size(); i++) {
																									Nodecpuconfig cpuconfig = (Nodecpuconfig) cpuconfiglist
																											.get(i);
																						%>
																						<tr bgcolor="#FFFFFFF" <%=onmouseoverstyle%>
																							height=25>
																							<td class="detail-data-body-list" align="center">
																								&nbsp;<%=cpuconfig.getDataWidth()%></td>
																							<td class="detail-data-body-list" align="center"><%=cpuconfig.getProcessorId()%></td>
																							<td class="detail-data-body-list" align="center"><%=cpuconfig.getName()%></td>
																							<td class="detail-data-body-list" align="center"><%=cpuconfig.getProcessorType()%></td>
																							<td class="detail-data-body-list" align="center"><%=cpuconfig.getProcessorSpeed()%></td>
																						</tr>
																						<%
																							}
																							}
																						%>
																					</table>
																				</td>
																			</tr>
																		</table>
																		<center>
																		<table width="80%" border="0" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
																			<tr>
																				<td height="28" align="left" bgcolor="#ECECEC" colspan=5>
																					&nbsp;&nbsp;
																					<b>内存配置信息</b>
																				</td>
																			</tr>
																			<tr align="center" bgcolor="#ECECEC" height=28>
																				<td width="70%" class="detail-data-body-title" align="center">
																					类型
																				</td>
																				<td width="30%" class="detail-data-body-title" align="center">
																					大小
																				</td>
																			</tr>

																			<tr bgcolor="#FFFFFF" <%=onmouseoverstyle%> height=28>
																				<td class="detail-data-body-list" align="center">
																					&nbsp;物理内存
																				</td>
																				<td class="detail-data-body-list" align="center">
																					&nbsp;<%=TotalVisibleMemorySize%></td>
																			</tr>
																			<tr bgcolor="#FFFFFF" <%=onmouseoverstyle%>
																				height=28>
																				<td class="detail-data-body-list" align="center">
																					&nbsp;Swap内存
																				</td>
																				<td class="detail-data-body-list" align="center">
																					&nbsp;<%=TotalSwapMemorySize%></td>
																			</tr>
																		</table>
																		<table width="80%" border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF">
																			<tr>
																				<td height="28" align="left" bgcolor="#ECECEC" colspan=5>
																					&nbsp;&nbsp;
																					<b>网卡配置信息</b>
																				</td>
																			</tr>
																			<tr align="center" bgcolor="#ECECEC" height=28>
																				<td width="25%" class="detail-data-body-title" align="center">
																					名称
																				</td>
																				<td width="25%" class="detail-data-body-title" align="center">
																					MAC
																				</td>
																				<td width="25%" class="detail-data-body-title" align="center">
																					速率
																				</td>
																				<td width="25%" class="detail-data-body-title" align="center">
																					状态
																				</td>
																			</tr> 
																		<%
																			if (netmedialist != null && netmedialist.size() > 0) {
																				for (int i = 0; i < netmedialist.size(); i++) {
																					Hashtable netmedia = (Hashtable) netmedialist.get(i);
																		%>
																			<tr bgcolor="#FFFFFF" <%=onmouseoverstyle%> height=28>
																				<td class="detail-data-body-list" align="center">&nbsp;<%=(String) netmedia.get("desc")%></td>
																				<td class="detail-data-body-list" align="center"><%=(String) netmedia.get("mac")%></td>
																				<td class="detail-data-body-list" align="center"><%=(String) netmedia.get("speed")%></td>
																				<td class="detail-data-body-list" align="center"><%=(String) netmedia.get("status")%></td>
																			</tr>
																		<%
																				}
																			}
																		%>
																		</table>
																		<table width="80%" border="0" cellpadding="0"
																			cellspacing="1" bgcolor="#FFFFFF">
																			<tr>
																				<td height="28" align="left" bordercolor="#397DBD"
																					bgcolor="#ECECEC" class="txtGlobalBold" colspan=8>
																					&nbsp;&nbsp;
																					<b>用户信息</b>
																				</td>
																			</tr>
																			<tr align="center" bgcolor="#ECECEC" height=28>
																				<td width="20%" class="detail-data-body-title"
																					align="center">
																					名称
																				</td>
																				<td width="20%" class="detail-data-body-title"
																					align="center">
																					用户组
																				</td>
																			</tr>

																		<%
																			if (userVector != null && userVector.size() > 0) {
																				for (int i = 0; i < userVector.size(); i++) {
																					Usercollectdata user = (Usercollectdata) userVector.get(i);
																		%>
																			<tr bgcolor="#FFFFFF" <%=onmouseoverstyle%> height=28>
																				<td class="detail-data-body-list" align="center"> &nbsp;<%=(String) user.getThevalue()%></td>
																				<td class="detail-data-body-list" align="center"> &nbsp;<%=(String) user.getSubentity()%></td>
																			</tr>
																		<%
																				}
																			}
																		%>
																		</table>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
								<td class="td-container-main-tool" width=15%>
									<jsp:include page="/include/toolbar.jsp">
										<jsp:param value="<%=host.getIpAddress()%>" name="ipaddress" />
										<jsp:param value="<%=host.getSysOid()%>" name="sys_oid" />
										<jsp:param value="<%=tmp%>" name="tmp" />
										<jsp:param value="host" name="category" />
										<jsp:param value="aix" name="subtype" />
									</jsp:include>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>