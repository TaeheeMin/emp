package vo;

public class DeptEmp {
	// 테이블 컬럼과 동일한 vo(도메인)타입
	// join결과 받을 수 없음
	/*
	public int empNo;
	public int deptNo;
	 */
	
	// dept_emp 테이블의 한 행 + join 결과 행도 처리 가능
	// 단점 -> 복잡
	public Employee emp;
	public Department dept;
	public String fromDate;
	public String toDate;	
}
