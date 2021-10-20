<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme
() + "://" + request.getServerName() + ":" + request.getServerPort
() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>



	<script type="text/javascript">

	$(function(){
		//为创建按钮绑定事件，打开添加模态窗口

		$("#addBtn").click(function (){

			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});



			/*
			* 操作模态窗口的方式
			* 		需要操作的模态窗口的jquery对象，调用modal方法，为该方法
			* 传递参数，分别为show：打开模态窗口  hide：关闭模态窗口
			*
			*
			* */
			//alert(123)
			//$("#createActivityModal").modal("show");


			//走后台，目的是为了去得用户信息列表，为所有者下拉框铺值

			$.ajax({
				url:"workbench/activity/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data){

					/*
					* data
					* 	[{"id":?,"name":?,.....}，{用户2}，{用户3}.....]
					*
					* */


					var html = "<option></option>"

					//遍历出来的每一个n，就是每个user对象
					$.each(data,function (i,n){
						html += "<option value='" +  n.id + "'>"+ n.name + "</option>"
					})



					//为option加值
					$("#create-marketActivityOwner").html(html);

					//将当前登录的用户，设置为下拉框默认的选项
					//在js中使用el表达式，el表达式一定要套用在字符串中
					var id = "${user.id}"
					$("#create-marketActivityOwner").val(id);

					//打开模态窗口

					$("#createActivityModal").modal("show");
				}


			})

		})


		//为保存按钮添加事件，进行添加操作
		$("#saveBtn").click(function (){

			$.ajax({
				url:"workbench/activity/save.do",
				data:{
					//发送表单参数
					"owner" : $.trim($("#create-marketActivityOwner").val()),
					"name" :$.trim($("#create-marketActivityName").val()),
					"startDate" :$.trim($("#create-startTime").val()),
					"endDate" :$.trim($("#create-endTime").val()),
					"cost" :$.trim($("#create-cost").val()),
					"description" :$.trim($("#create-describe").val()),

				},
				type:"post",
				dataType:"json",
				success:function (data){
					/*
					* data
					* 		{"success":true/false}
					*
					*
					* */

					if(data.success){

						//添加成功后，刷新市场活动信息列表（局部刷新）

						//pageList(1,2);
						pageList(1
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


						//清空添加操作模态窗口的数据
						/*
						* jquery对象转换为dom对象
						*		jquery对象[下标]
						*
						* dom对象转换为jquery对象
						* 		$(dom)
						*
						* */
						$("#activityAddForm")[0].reset();
						//关闭添加操作的模态窗口
						$("#createActivityModal").modal("hide");

					}else {
						alert("添加市场活动成功")
					}



				}


			})

		})


		//页面加载完毕后触发一个方法
		//默认展开列表第一页，每个2条数据
		pageList(1,2);

		//为查询绑定事件，触发pageList方法
		$("#searchBtn").click(function (){

			/*
			* 点击查询按钮，我们应该将搜索框中的信息保存起来，保存在隐藏域中
			*
			* */

			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));
			pageList(1,2);


		})


		//为全选的复选框绑定事件，触发全选
		$("#qx").click(function (){

			$("input[name=xz]").prop("checked",this.checked);


			/*
			* 动态生成的元素，不能使用普通的绑定事件进行绑定
			*
			* 需要通过特殊的方式on来进行绑定事件
			* 语法：$(需要绑定的有效的外层元素).on(绑定事件的方式，需要绑定元素的jquery对象，回调函数)
			*
			*
			*
			* */
			$("#activityTBody").on("click",$("input[name=xz]"),function (){

				$("#qx").prop("checked",$("input[name=xz]").length == $("input[name=xz]:checked").length)


			})

		})


		//为删除按钮绑定事件，执行市场活动删除
		$("#deleteBtn").click(function (){

			//找到所有选择中的复选框的jquery对象
			var $xz = $("input[name=xz]:checked");
			if($xz.length == 0){

				alert("请选择需要删除的记录");

				//选择了数据，可能是一条或者多条
			}else {

				if(confirm("你确认删除吗？")){
//url:workbench/activity/delete.do?id=xx&id=xxx

					//拼接参数
					var param ="";

					//将$xz中的每一个dom对象遍历出来，取得其value值，就相当于取得了需要删除的id
					for(var i=0;i<$xz.length;i++){

						param += "id=" + $($xz[i]).val();

						//如果不是最后一个元素，需要在后面加一个&
						if(i<$xz.length-1){
							param += "&";
						}


					}
					//alert(param)
					$.ajax({
						url:"workbench/activity/delete.do",
						data: param,
						type:"post",
						dataType:"json",
						success:function (data){

							/*
                            * data
                            * 		{"success": true}
                            *
                            * */

							if(data.success) {

								//删除成功后
								//pageList(1,2);
								pageList(1
										,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


							}else {

								alert("删除市场活动失败");
							}

						}


					})


				}


			}


		})


		//为修改按钮绑定事件，打开操作修改模态框
			$("#editBtn").click(function (){
				var $xz = $("input[name=xz]:checked");
				if($xz.length == 0){
					alert("请选择需要修改的记录");
				}else if($xz.length > 1){
					alert("只能选择一条记录")

					//肯定只选择了一个
				}else {

					var id = $xz.val();
					$.ajax({
						url:"workbench/activity/getUserListAndActivity.do",
						data:{

							"id" : id
						},
						type:"get",
						dataType:"json",
						success:function (data){

							/*
							* data
							* 		用户列表
							* 		市场活动对象
							*
							* 	{"uList":[{用户1},....],"a":{}}
							*
							*
							* */
							//处理所有者下拉框
							var html = "<option></option>";

							$.each(data.uList,function (i,n){
								html += "<option value='"+ n.id +"'>"+ n.name +"</option>";
							})

							$("#edit-marketActivityOwner").html(html);


							//处理单条activity
							$("#edit-id").val(data.a.id);
							$("#edit-marketActivityName").val(data.a.name);
							$("#edit-marketActivityOwner").val(data.a.owner);
							$("#edit-startTime").val(data.a.startDate);
							$("#edit-endTime").val(data.a.endDate);
							$("#edit-cost").val(data.a.cost);
							$("#edit-describe").val(data.a.description);

							//所有的值都填写好以后打开模态窗口

							$("#editActivityModal").modal("show");



						}


					})

				}

			})


		//为更新按钮绑定事件，执行市场活动的修改操作
		/*
		* 先做添加再做修改
		*
		* */
		$("#updateBtn").click(function (){

			$.ajax({
				url:"workbench/activity/update.do",
				data:{
					//发送表单参数
					"id":$.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-marketActivityOwner").val()),
					"name" :$.trim($("#edit-marketActivityName").val()),
					"startDate" :$.trim($("#edit-startTime").val()),
					"endDate" :$.trim($("#edit-endTime").val()),
					"cost" :$.trim($("#edit-cost").val()),
					"description" :$.trim($("#edit-describe").val()),

				},
				type:"post",
				dataType:"json",
				success:function (data){
					/*
					* data
					* 		{"success":true/false}
					*
					*
					* */

					if(data.success){

						//修改成功后，刷新市场活动信息列表（局部刷新）
						//pageList(1,2);
						/*
						* 修改操作后应该维持在当前页
						* */
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


						//关闭修改操作的模态窗口
						$("#editActivityModal").modal("hide");

					}else {
						alert("修改市场活动成功")
					}



				}


			})

		})
		
	});

	/*
	*所有的关系型数据库，做前端分页相关操作的基础组件
	* 就是pageNo和pageSize
	* 	pageNo是第几页的意思
	* 	pageSize是指每页展现的记录数
	*
	*pageList方法：就是通过发出ajax请求到后台，从后台取得最新的市场信息列表数据后
	* 通过响应回来的数据，进行局部刷新
	*
	* 我们需要在什么情况下调用pageList方法
	* 			1.点击左侧菜单中的“市场活动”
	* 			2.添加，修改，删除都需要刷新列表数据
	* 			3.点击查询按钮，需要刷新
	* 			4.点击分页组件需要刷新数据
	*
	* */
	function pageList(pageNo,pageSize){
		//讲全选的复选框
		$("#qx").prop("checked",false);

		//查询前，将隐藏域中保存的信息放入搜索中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));

		$.ajax({
			url:"workbench/activity/pageList.do",
			data:{
				"pageNo" :pageNo,
				"pageSize" :pageSize,
				"owner" : $.trim($("#search-owner").val()),
				"name" :$.trim($("#search-name").val()),
				"startDate" :$.trim($("#search-startDate").val()),
				"endDate" :$.trim($("#search-endDate").val()),

			},
			type:"get",
			dataType:"json",
			success:function (data){
				/*
				* data
				* 		[{市场活动1},......]
				*
				* 		分页查询需要的数据[{"total":100]
				*
				*
				* */

				var html = "";
				//每一个n就是一个市场活动对象
				$.each(data.dataList,function (i,n){

					html += '<tr class="active">';
					html += '<td><input type="checkbox"  name="xz" value="'+ n.id+ '"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id=' + n.id +'\';">'+ n.name + '</a></td>';
                    html += '<td>'+ n.owner + '</td>';
					html += '<td>'+ n.startDate + '</td>';
					html += '<td>'+ n.endDate + '</td>';
					html += '</tr>';

				})
				$("#activityTBody").html(html);

				//计算总条数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize) + 1


				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数


					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					//该回调函数，在点击分页组件触发
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
				//alert(totalPages)



			}


		})

	}
	
</script>
</head>
<body>

	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">


	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<%-- data-dismiss:表示关闭--%>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime" >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<!--
										关于文本域
											（1）一定要以标签的形式呈现，正常状态下标签的要紧紧的挨着
											（2）textarea虽然是标签对形式出现，但它也属于表单元素，应该使用val赋值

								-->
								<textarea class="form-control" rows="3" id="edit-describe">123</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">

					<!--
					 		点击创建按钮，观察两个属性和属性值

					 		data-toggle ="modal"
					 				表示触发该按钮，将要打开一个模态窗口


							data-target="#createActivityModal"
									表示要打开哪个模态窗口，通过#id的形式找到该窗口

							现在我们是用属性和属性值得方式写在button上

								问题在于没有办法为按钮的功能进行扩充
							所以未来的实际项目开发，对于触发模态窗口的操作，一定不要写死在元素中，应该使用我们自己的js打开模态窗口




					 -->
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityTBody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">

				<div id="activityPage" >


				</div>

			</div>
			
		</div>
		
	</div>
</body>
</html>