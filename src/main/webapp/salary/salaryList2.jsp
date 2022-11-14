<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.HashMap" %> <!-- map 타입 사용 -->
<%@ page import = "java.util.ArrayList" %> 
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	// map 타입의 이해
	// map 사용안하면 -> class 사용 -> 매번 클래스(vo)를 만들어야함
	Student s = new Student();
	s.name = "민태희";
	s.age = 29;
	System.out.println("s.name : " + s.name);
	System.out.println("s.age : " + s.age);
	
	// Student class가 없다면 hash map 사용 -> 익명 객체
	HashMap<String, Object> m = new HashMap<String, Object>();
	m.put("name", "김태희");
	m.put("age", 30); // 값 넣을 때
	System.out.println("hash map name : " + m.get("name"));
	System.out.println("hash map age : " + m.get("age"));
	
	// 배열 집합이면
	// 1) class 사용
	Student s1 = new Student();
	s1.name = "민태희";
	s1.age = 20;
	Student s2 = new Student();
	s2.name = "박성환";
	s2.age = 33;
	ArrayList<Student> studentList = new ArrayList<Student>();
	studentList.add(s1);
	studentList.add(s2);
	System.out.println("studentList 출력");
	for(Student st : studentList){
		System.out.println(st.name + st.age);
	}
	
	// 2) map 사용
	HashMap<String, Object> m1 = new HashMap<String, Object>();
	m1.put("name", "김성환");
	m1.put("age", 15);
	HashMap<String, Object> m2 = new HashMap<String, Object>();
	m2.put("name", "최성환");
	m2.put("age", 40);
	ArrayList<HashMap<String, Object>> mapList = new ArrayList<HashMap<String, Object>>();
	mapList.add(m1);
	mapList.add(m2);
	System.out.println("mapList 출력");
	for(HashMap<String, Object> hm : mapList){
		System.out.println(hm.get("name"));
		System.out.println(hm.get("age"));
	}
	
	// 1. 요청 분석
	// 페이징
	request.setCharacterEncoding("utf-8");
	// 2. 요청 처리
	// db연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	
	<body>
		
	</body>
</html>