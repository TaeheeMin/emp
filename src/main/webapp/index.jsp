<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>index</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			body {
				padding:1.5em;
				background: #f5f5f5
			}

			table {
			 	border: 1px #a39485 solid;
				font-size: .9em;
				box-shadow: 0 2px 5px rgba(0,0,0,.25);
				width: 100%;
				border-collapse: collapse;
				border-radius: 5px;
				overflow: hidden;
				text-align:center;
			}
			a {
			text-decoration: none;
			}
		</style>
	</head>
	
	<body>
		<h1 class="text-center">INDEX</h1>
		
		<div class = "container">
			<table class = "table table-hover w-50 rounded" style="table-layout: auto; width: 50%; table-layout: fixed;"> 
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
					</td>
					<td>
						<a href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>