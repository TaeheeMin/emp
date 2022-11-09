<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>index</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<style type="text/css">
			container {
				background-color: white;
				border-radius: 4px;
				text-align: center;
				margin-bottom: 40px;
			}
		</style>
	</head>
	
	<body>
		<h1>INDEX</h1>
			<a href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
			<a href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
	</body>
</html>