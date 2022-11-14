package vo;

public class Salary {
	// 1) public int empNo;
	// Employee객체 필요없음, 조인 결과 못가져옴
	public Employee emp;
	// 2) emp_no을 받아오는게 아니라 Employee로 받아오는 방법
	// 조인 결과물 받아올 수 있음, Employee객체를 항상 하나씩 만들어줘야 함 
	public int salary;
	public String fromDate;
	public String toDate;
	
	/* 사용 예시
	public static void main(String[] args) {
		Salary s = new Salary();
		s.emp = new Employee();
		s.emp.empNo = 1;
		s.salary = 5000;
		s.fromDate = "2021-01-01";
		s.toDate = "2021-12-31";
	}
	*/
} 
