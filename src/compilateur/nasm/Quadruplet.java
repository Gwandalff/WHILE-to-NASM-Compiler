package compilateur.nasm;

public class Quadruplet {
	private String op;
	private String adCible;
	private String adSource1;
	private String adSource2;
	
	public Quadruplet(String op, String adCible, String adSource1, String adSource2) {
		this.op = op;
		this.adCible = adCible;
		this.adSource1 = adSource1;
		this.adSource2 = adSource2;
	}
	
	public String getop() {
		return op;
	}
	public void setop(String op) {
		this.op = op;
	}
	public String getadCible() {
		return adCible;
	}
	public void setadCible(String adCible) {
		this.adCible = adCible;
	}
	public String getadSource1() {
		return adSource1;
	}
	public void setadSource1(String adSource1) {
		this.adSource1 = adSource1;
	}
	public String getadSource2() {
		return adSource2;
	}
	public void setadSource2(String adSource2) {
		this.adSource2 = adSource2;
	}

	private String espaces(int n) {
		String res = "";
		for (int i = 0; i < n; i++)
			res += " ";
		return res;
	}
	
	public String toString() {
		return "< " + getop() + espaces(9 - getop().length()) + " - " 
				+ getadCible() + espaces(5 - getadCible().length()) + " - "
				+ getadSource1() + espaces(5 - getadSource1().length()) + " - "
				+ getadSource2() + espaces(5 - getadSource2().length()) + " >" ;
	}
	
}
