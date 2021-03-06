package com.gatherResulttosql;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

import com.afunms.common.util.SysUtil;
import com.afunms.polling.om.Diskcollectdata;
import com.gatherdb.GathersqlListManager;

public class HostdiskResultosql {
	
	
	public void CreateResultTosql(Hashtable ipdata,String ip)
	{
	
		String allipstr = SysUtil.doip(ip);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
	if(ipdata.containsKey("disk")){
		//disk
		Vector diskVector=null; 
		Diskcollectdata  diskdata=null;
		diskVector = (Vector) ipdata.get("disk");
		//diskhash = null;
		if (diskVector != null && diskVector.size() > 0) {
			for (int si = 0; si < diskVector.size(); si++) {
				diskdata = (Diskcollectdata) diskVector.elementAt(si);
				if (diskdata.getRestype().equals("dynamic")) {
					Calendar tempCal = (Calendar) diskdata.getCollecttime();
					Date cc = tempCal.getTime();
					String time = sdf.format(cc);
					String tablename = "diskincre" + allipstr;
					String sequenceName = tablename+"SEQ";
					String sql = "upsert into " + tablename
							+ "(id,ipaddress,category,subentity,restype,entity,thevalue,collecttime,unit) "
							+ "values(next value for "+sequenceName+",'"+ ip + "','" + diskdata.getCategory() + "','"+ diskdata.getSubentity() 
							+ "','" + diskdata.getRestype()+ "','" + diskdata.getEntity() + "','"
							+ diskdata.getThevalue() + "','" + time + "','" + diskdata.getUnit() + "')";
					
					
					System.out.println("===="+sql);
					GathersqlListManager.Addsql(sql);
					sql=null;
					time=null;
					cc=null;
					tempCal=null;
					
				}
				if (diskdata.getEntity().equals("Utilization")) {
					Calendar tempCal = (Calendar) diskdata.getCollecttime();
					Date cc = tempCal.getTime();
					String time = sdf.format(cc);
					String tablename = "disk" + allipstr;
					String sequenceName = tablename+"SEQ";
					String sql = "upsert into " + tablename
							+ "(id,ipaddress,category,subentity,restype,entity,thevalue,collecttime,unit) "
							+ "values(next value for "+sequenceName+",'"+ ip + "','" + diskdata.getCategory() + "','"+ diskdata.getSubentity() 
							+ "','" + diskdata.getRestype()+ "','" + diskdata.getEntity() + "','"
							+ diskdata.getThevalue() + "','" + time + "','" + diskdata.getUnit() + "')";
				
					//System.out.println(sql);
					
					GathersqlListManager.Addsql(sql);
					sql=null;
					//time=null;
					//cc=null;
					//tempCal=null;
					
				}
				diskdata = null;
			}
		}
		diskVector = null;
	}
	
	}

}
