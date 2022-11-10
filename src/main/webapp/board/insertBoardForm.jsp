<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>게시글 등록</title>
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
			input, textarea{
			 	display: inline-block;
				font-size: 15px;
				border: 0;
				border-radius: 15px;
				outline: none;
				padding-left: 10px;
				background-color: rgb(233, 233, 233);
				float: left;
			}
			textarea {
				width:100%;
				height:150px;
			}
			#title {
				width:100%;
			}
		</style>
	</head>
	
	<body>
		<!-- 메뉴 partial jsp 구성-->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		
		<div> <!-- 제목 -->
			<h1 class="text-center">
				게시글 등록
			</h1>
		</div>
			
		<%
		if(request.getParameter("msg") != null){
		%>
		<div class="text-center"><%=request.getParameter("msg")%></div>
		<%
		}
		%>
		<div class="container">
			<!-- msg 파라미터값이 있으면 출력 -->
			<form  method="post" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
				<table class="table table-bordered table-hover w-100 rounded" style="margin-left: auto; margin-right: auto;"> 
					<tr>
						<td>TITLE</td>
						<td>
							<input id="title" type="text" name="boardTitle" placeholder="제목을 입력해주세요" > 
						</td>
					</tr>
					<tr>
						<td>CONTENT</td>
						<td>
							<textarea rows="10" cols="50" name="boardContent" placeholder="내용을 입력해주세요"></textarea>
						</td>
					</tr>
					<tr>
						<td>WRITER</td>
						<td>
							<input type="text" name="boardWriter"> 
						</td>
					</tr>
					<tr>
						<td>PASSWORD</td>
						<td>
							<input type="password" name="pw1" placeholder="비밀번호">
							<input type="password" name="pw2" placeholder="비밀번호 확인">
						</td>
					</tr>
					<tr>
						<td colspan ="2">
							<button type="submit" class="btn text-black .bg-dark.bg-gradient"  style="background-color:#D4D4D4;">ADD</button>
						</td>
					</tr>
				</table>
			</form>
		</div>	
	</body>
</html>