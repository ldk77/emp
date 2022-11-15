package vo;

public class DeptEmp {
	// 테이블 컬럼과 일치하는 도메인 타입 
	// 단점 : JOIN결과를 처리할수가 없다
	/* 그래서 안쓸거임
	public int empNo;
	public int deptNo;
	*/
	
	// 장점 : dept_emp 테이블의 행뿐만 아니라 + JOIN결과의 행도 처리 할 수 있다
	// 단점 : 복잡하다. 
	public Employee emp; 
	public Department dept;
	public String fromDate;
	public String toDate;
}
