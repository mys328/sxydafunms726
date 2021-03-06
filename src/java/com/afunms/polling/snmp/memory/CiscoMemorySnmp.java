package com.afunms.polling.snmp.memory;


/*
 * @author hukelei@dhcc.com.cn
 *
 */

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

import com.afunms.common.util.ShareData;
import com.afunms.common.util.SnmpUtils;
import com.afunms.indicators.model.NodeGatherIndicators;
import com.afunms.monitor.executor.base.SnmpMonitor;
import com.afunms.monitor.item.base.MonitoredItem;
import com.afunms.polling.PollingEngine;
import com.afunms.polling.base.Node;
import com.afunms.polling.node.Host;
import com.afunms.polling.om.CPUcollectdata;
import com.afunms.polling.om.Memorycollectdata;
import com.afunms.topology.model.HostNode;
import com.gatherResulttosql.NetHostMemoryRtsql;
import com.gatherResulttosql.NetmemoryResultTosql;


/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class CiscoMemorySnmp extends SnmpMonitor {
	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	/**
	 * 
	 */
	public CiscoMemorySnmp() {
	}

	   public void collectData(Node node,MonitoredItem item){
		   
	   }
	   public void collectData(HostNode node){
		   
	   }
	/* (non-Javadoc)
	 * @see com.dhcc.webnms.host.snmp.AbstractSnmp#collectData()
	 */
	public Hashtable collect_Data(NodeGatherIndicators alarmIndicatorsNode) {	
		//yangjun
		Hashtable returnHash=new Hashtable();
		Vector memoryVector=new Vector();
		List memoryList = new ArrayList();
		Host node = (Host)PollingEngine.getInstance().getNodeByID(Integer.parseInt(alarmIndicatorsNode.getNodeid()));
		if(node == null)return null;
		
		try {
			CPUcollectdata cpudata=null;
			Calendar date=Calendar.getInstance();
			
			  try{
				  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				  com.afunms.polling.base.Node snmpnode = (com.afunms.polling.base.Node)PollingEngine.getInstance().getNodeByIP(node.getIpAddress());
				  Date cc = date.getTime();
				  String time = sdf.format(cc);
				  snmpnode.setLastTime(time);
			  }catch(Exception e){
				  
			  }
			  try {
				  //-------------------------------------------------------------------------------------------内存 start
		   		  String temp = "0";
		   		  if(node.getSysOid().startsWith("1.3.6.1.4.1.9.")){
		   			String[][] valueArray = null;
		   			String[] oids =                
						  new String[] {               
							"1.3.6.1.4.1.9.9.48.1.1.1.5",//ciscoMemoryPoolUsed
							"1.3.6.1.4.1.9.9.48.1.1.1.6"//ciscoMemoryPoolFree
		   			};
		   			valueArray = SnmpUtils.getTemperatureTableData(node.getIpAddress(), node.getCommunity(), oids, node.getSnmpversion(), 3, 1000*30);
		   			int allvalue=0;
		   			int flag = 0;
					if(valueArray != null){
					   	  for(int i=0;i<valueArray.length;i++)
					   	  {
					   		String usedvalue = valueArray[i][0];
					   		String freevalue = valueArray[i][1];
					   		String index = valueArray[i][2];
					   		//SysLogger.info(node.getIpAddress()+"   usedvalue==="+usedvalue);
					   		float value=0.0f;
					   		//int value=0;
					   		String usedperc = "0";
					   		try{
					   		if(Long.parseLong(freevalue)+Long.parseLong(usedvalue) > 0)
					   			value = Long.parseLong(usedvalue)*100/(Long.parseLong(freevalue)+Long.parseLong(usedvalue));
					   		}catch(Exception e){
					   			
					   		}
							if( value >0){
								int intvalue = Math.round(value); 
								flag = flag +1;
						   		List alist = new ArrayList();
						   		alist.add("");
						   		alist.add(usedperc);
						   		//内存
						   		memoryList.add(alist);	
						   		Memorycollectdata memorycollectdata = new Memorycollectdata();
						   		memorycollectdata.setIpaddress(node.getIpAddress());
						   		memorycollectdata.setCollecttime(date);
						   		memorycollectdata.setCategory("Memory");
						   		memorycollectdata.setEntity("Utilization");
						   		memorycollectdata.setSubentity(index);
						   		memorycollectdata.setRestype("dynamic");
						   		memorycollectdata.setUnit("");		
						   		memorycollectdata.setThevalue(intvalue+"");
								memoryVector.addElement(memorycollectdata);
						   		
							}
					   	  }
					}
		   		  }
		   		//memoryVector.add(memoryList);
		   	  }
		   	  catch(Exception e)
		   	  {
		   		  e.printStackTrace();
		   	  }	   	  
		   	  //-------------------------------------------------------------------------------------------内存 end	
		}
		catch(Exception e){
			//returnHash=null;
			//e.printStackTrace();
			//return null;
		}
		
//		Hashtable ipAllData = new Hashtable();
//		try{
//			ipAllData = (Hashtable)ShareData.getSharedata().get(node.getIpAddress());
//		}catch(Exception e){
//			
//		}
//		if(ipAllData == null)ipAllData = new Hashtable();
//		if (memoryVector != null && memoryVector.size()>0)ipAllData.put("memory",memoryVector);
//	    ShareData.getSharedata().put(node.getIpAddress(), ipAllData);
//	    returnHash.put("memory",memoryVector);
	    
		if (!(ShareData.getSharedata().containsKey(node.getIpAddress()))) {
			Hashtable ipAllData = new Hashtable();
			if (ipAllData == null) ipAllData = new Hashtable();
			if (memoryVector != null && memoryVector.size() > 0) ipAllData.put("memory", memoryVector);
				ShareData.getSharedata().put(node.getIpAddress(), ipAllData);
			} 
		else{
			if (memoryVector != null && memoryVector.size() > 0) ((Hashtable) ShareData.getSharedata().get(node.getIpAddress())) .put("memory", memoryVector);
		}	
	    returnHash.put("memory",memoryVector);
	    
	    
//	    ipAllData=null;
	    memoryVector=null;
	    
	    //把采集结果生成sql
	    NetmemoryResultTosql tosql=new NetmemoryResultTosql();
	    tosql.CreateResultTosql(returnHash, node.getIpAddress());
	    NetHostMemoryRtsql  totempsql=new NetHostMemoryRtsql();
	    totempsql.CreateResultTosql(returnHash, node);
	    
	    return returnHash;
	}
}





