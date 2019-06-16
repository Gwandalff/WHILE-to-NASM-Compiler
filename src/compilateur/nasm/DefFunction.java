package compilateur.nasm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


public class DefFunction {
	
	private int numVar;
	private String name;
	private List<String> inputs;
	private List<String> outputs;
	private HashMap<String,String> variables;
	private List<Quadruplet> codeI;
	private List<Quadruplet> codeImort;
	
	public DefFunction(String name) {
		numVar = 0;
		this.name = name;
		this.variables = new HashMap<String,String>();
		this.codeI = new ArrayList<Quadruplet>();
		this.codeImort = new ArrayList<Quadruplet>();
		this.inputs = new ArrayList<String>();
		this.outputs = new ArrayList<String>();
	}
	
	public int getNbVar() {
		return numVar;
	}
	public String getName() {
		return name;
	}
	public int getNbInput() {
		return inputs.size();
	}
	public int getNbOutput() {
		return outputs.size();
	}
	public HashMap<String,String> getVariables() {
		return variables;
	}
	public void addInput(String i) {
		inputs.add(i);
	}
	public void addOutput(String o) {
		outputs.add(o);
	}
	public List<String> getInputs() {
		return inputs;
	}
	public List<String> getOutputs() {
		return outputs;
	}
	public void addCodeI(String op, String adCible, String adSource1, String adSource2) {
		codeI.add(new Quadruplet(op, adCible, adSource1, adSource2));
	}
	public Quadruplet getCodeI(int index) {
		return codeI.get(index);
	}
	public List<Quadruplet> getCodeI() {
		return codeI;
	}
	public String getVar(String var) {
		return variables.get(var);
	}	
	public List<Quadruplet> getCodeImort() {
		return codeImort;
	}
	public void addCodeIMort(Quadruplet q) {
		codeImort.add(q);
	}
	
	public String toString(){
		String res = "";
		res += "Nombre d'entrees : " + inputs.size() + "\n";
		res += "Variables d'entrees : ";
		for (String v : inputs)
			res += v + " ";
		res += "\nNombre de sorties : " + outputs.size() + "\n";
		res += "Variables de sorties : ";
		for (String v : outputs)
			res += v + " ";
		res += "\n\nTable des variables : ";
		for (String vars : variables.keySet())
			res+= "\n  " + vars + " -> "+ variables.get(vars);
		res += "\n\nCode intermediaire:";
			for (Quadruplet q : codeI)
				res += "\n  " + q.toString();
		res += "\n\nCode mort enlevé :";
		for (Quadruplet q : codeImort)
			res += "\n  " + q.toString();
		return res + "\n";
	}
	public String newVar(String var) {
		if (variables.containsKey(var))
			return variables.get(var);
		numVar++;
		String var2 = "V" + numVar;
		variables.put(var, var2);
		return var2;
	}
	
	public String newVar() {
		numVar++;
		return "V" + numVar;
	}
}

