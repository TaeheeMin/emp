<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- partial jsp 페이지 사용 코드 -->
	<nav id="nav" class="navbar navbar-expand-sm bg-dark navbar-dark">
			<div class="container-fluid">
				<a class="navbar-brand" href="<%=request.getContextPath()%>/index.jsp">GOODEE</a>
				<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#collapsibleNavbar">
					<span class="navbar-toggler-icon"></span>
				</button>
	  		<div class="collapse navbar-collapse" id="collapsibleNavbar">
	    		<ul class="navbar-nav">
			      <li class="nav-item">
			        <a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">홈으로</a>
			        </li>
			        <li class="nav-item">
			          <a class="nav-link" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
			        </li>
			        <li class="nav-item">
			          <a class="nav-link" href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
			        </li>
			        <li class="nav-item">
			          <a class="nav-link" href="<%=request.getContextPath()%>/salary/salaryList.jsp">연봉관리</a>
			        </li>
			        <li class="nav-item">
			          <a class="nav-link" href="<%=request.getContextPath()%>/board/boardList.jsp">게시판관리</a>
			        </li>
			      </ul>
			    </div>
	 		</div>
		</nav>
