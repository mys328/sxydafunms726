<%@page language="java" contentType="text/html;charset=gb2312" %>
<%@ include file="/include/globe.inc"%>
<%@ include file="/include/globeChinese.inc"%>

<%
	String rootPath = request.getContextPath();
	String menuTable = (String)request.getAttribute("menuTable");
	String nodeid = (String)request.getAttribute("nodeid");
	String type = (String)request.getAttribute("type");
	String subtype = (String)request.getAttribute("subtype");
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		
		<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css"/>
		
		<script language="JavaScript" src="<%=rootPath%>/include/date.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>
		<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 
		<script type="text/javascript" src="<%=rootPath%>/js/dwr/engine.js"></script> 
		<script type="text/javascript" src="<%=rootPath%>/js/dwr/util.js"></script> 
		<script type="text/javascript" src="<%=rootPath%>/js/detail/storagedetail.js"></script> 
		<script type="text/javascript" src="<%=rootPath%>/dwr/interface/StorageRemoteService.js"></script>
		
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
			}
			
		</script>
		
		<script type="text/javascript">
			/**
			 * 根据传入 div 的 id 显示右键菜单
			 
			function showMenu(divid, )
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
			*/
			/**
			*显示弹出菜单
			*menuDiv:右键菜单的内容
			*width:行显示的宽度
			*rowControlString:行控制字符串，0表示不显示，1表示显示，如“101”，则表示第1、3行显示，第2行不显示
			*/
			function popMenu(menuDivId,width,rowControlString)
			{
			    //创建弹出菜单
			    //var pop = window.createPopup();
			    //设置弹出菜单的内容
			    //pop.document.body.innerHTML= document.getElementById(menuDiv).innerHTML;
			    
			    var menuDiv = document.getElementById(menuDivId);
			    menuDiv.style.display = "inline";
			    var rowObjs = menuDiv.all[0].rows;
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
			         //设置该行的高度
			        rowObjs[i].style.height = "25";
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
			    menuDiv.document.oncontextmenu=function()
			    {
			            return false; 
			    }
			    //选择右键菜单的一项后，菜单隐藏
			    menuDiv.document.onclick=function()
			    {
			        menuDiv.style.display = "none";
			    }
			    //显示菜单
			    var elmt = event.srcElement; 
			    var offsetTop = elmt.offsetTop; 
				var offsetLeft = elmt.offsetLeft; 
			    var offsetWidth = elmt.offsetWidth; 
			    var offsetHeight = elmt.offsetHeight; 
			    while( elmt = elmt.offsetParent ) 
			    { 
			          // add this judge 
			        if ( elmt.style.position == 'absolute' || elmt.style.position == 'relative'  
			            || ( elmt.style.overflow != 'visible' && elmt.style.overflow != '' ) ) 
			        { 
			            break; 
			        }  
			        offsetTop += elmt.offsetTop; 
			        offsetLeft += elmt.offsetLeft; 
			    }
			    
			    menuDiv.style.posLeft = offsetLeft;
			    menuDiv.style.posTop = offsetTop;
			    return true;
			}
		
		</script>
	</head>
	<body id="body" class="body" onload="initmenu();">
		<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 scrolling=no src="<%=rootPath%>/include/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
		<form id="mainForm" method="post" name="mainForm">
			<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid%>">
			<input type="hidden" id="type" name="type" value="<%=type%>">
			<input type="hidden" id="subtype" name="subtype" value="<%=subtype%>">
			<input type="hidden" id="rootPath" name="rootPath" value="<%=rootPath%>">
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
								<td class="td-container-main-detail">
									<table id="container-main-detail" class="container-main-detail">
										<tr>
											<td>
												<table id="detail-content" class="detail-content">
													<tr>
														<td>
															<table id="detail-content-header" class="detail-content-header">
											                	<tr>
												                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
												                	<td class="detail-content-title">设备详细信息</td><td class="detail-content-title"><input type="button" id="freshSystemInfo" value="刷新"></td>
												                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
												       			</tr>
												        	</table>
					        							</td>
					        						</tr>
					        						<tr>
					        							<td>
					        								<table id="detail-content-body" class="detail-content-body">
					        									<tr>
					        										<td>
					        											<div id="systemInfo">
					        												<!-- 此 div 用于显示设备系统信息 -->
					        												<table>
												               					<tr>
												               						<td id="systemInfo_1" width="80%">
												               							<table>
								                    										<tr>
								                      											<td width="30%" height="29">&nbsp;名称:</td>
								                      											<td width="70%" id="systemInfo_name"></td>
								                    										</tr>
								                    										<tr bgcolor="#F1F1F1">
								                      											<td width="30%" height="29">&nbsp;IP地址:</td>
								                      											<td width="70%" id="systemInfo_ipaddress"></td>
								                    										</tr>                    										
								                    										<tr >
								                    										
								                      											<td width="30%" height="29">&nbsp;管理状态:</td>
								                      											<td id="systemInfo_mon_flag"></td>
								                    										</tr>
								                    										<tr bgcolor="#F1F1F1">
								                      											<td width="30%" height="29">&nbsp;运行状态:</td>
								                      											<td width="70%" id="systemInfo_status"></td>
								                    										</tr>
								                    										<tr>
								                      											<td width="30%" height="29">&nbsp;型号:</td>
								                      											<td id="systemInfo_producerStr"></td>
								                    										</tr>
								                    										<tr bgcolor="#F1F1F1">
								                      											<td width="30%" height="29">&nbsp;序列号:</td>
								                      											<td width="70%" id="systemInfo_serialNumber"></td>
								                    										</tr>
				                    													</table>
				                    												</td>
				                    												<td id="systemInfo_2">
				                    													<table>
				                    														<tr>
				                    															<td id="currDayPingAvgInfo">
				                    															</td>
				                    														</tr>
				                    													</table>
				                    												</td>
				                    											</tr>                																	
				                											</table>
					        											</div>
					        										</td>
					        									</tr>
					        								</table>
					        							</td>
					        						</tr>
					        						<tr>
					        							<td>
					        								<table id="detail-content-footer" class="detail-content-footer">
					        									<tr>
					        										<td>
					        											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												                  			<tr>
												                    			<td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
												                    			<td></td>
												                    			<td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
												                  			</tr>
												              			</table>
					        										</td>
					        									</tr>
					        								</table>
					        							</td>
					        						</tr>
					        					</table>
											</td>
										</tr>
										<tr>
											<td>
												<table id="detail-data" class="detail-data">
													<tr>
												    	<td class="detail-data-header">
												    		<div id="detailTabDIV"><!-- 此 div 用于显示标签页 --></div>
												    	</td>
												  	</tr>
												  	<tr>
												    	<td>
												    		<table class="detail-data-body">
													      		<tr>
													      			<td>
													      				<div id="detailDataDIV">
													      					<!-- 此 div 用于显示当前标签页时的数据详细信息 -->
													      				</div>
															       	</td>
													      		</tr>
												    		</table>
												  		</td>
													</tr>
													<tr>
					        							<td>
					        								<table id="detail-content-footer" class="detail-content-footer">
					        									<tr>
					        										<td>
					        											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												                  			<tr>
												                    			<td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
												                    			<td></td>
												                    			<td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
												                  			</tr>
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
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>