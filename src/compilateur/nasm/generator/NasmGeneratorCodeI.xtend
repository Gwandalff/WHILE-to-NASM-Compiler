package compilateur.nasm.generator

import compilateur.nasm.nasm.Function
import compilateur.nasm.nasm.Input
import compilateur.nasm.nasm.Output
import compilateur.nasm.nasm.Commands
import compilateur.nasm.nasm.Command
import compilateur.nasm.nasm.Expr
import compilateur.nasm.nasm.ExprOr
import compilateur.nasm.nasm.ExprNot
import java.util.List
import compilateur.nasm.DefFunction
import compilateur.nasm.nasm.ExprEq
import compilateur.nasm.nasm.ExprSimple
import java.util.ArrayList

class NasmGeneratorCodeI {
	
	def compileI(Function f){
		if (Main.fonctions.containsKey(f.funcName))
			System.err.println("Erreur : la fonction "+f.funcName+" est définie plusieurs fois.");
		Main.numFonc++
		var fonction = new DefFunction("F"+Main.numFonc)
		Main.fonctions.put(f.funcName, fonction)
		f.input.compileI(fonction)
		f.coms.compileI(fonction)
		f.output.compileI(fonction)
	}

	def compileI(Input i, DefFunction f){
		for (v : i.varsIn){
			var variable = f.newVar(v)
			f.addCodeI("READ",variable,"","")
			f.addInput(variable)
		}
	}
	
	def compileI(Output o, DefFunction f){
		for (v : o.varsOut){
			var variable = f.newVar(v)
			f.addCodeI("WRITE","",f.newVar(v),"")
			f.addOutput(variable)
		}
	}
	
	def void compileI(Commands c, DefFunction f){
		for (com : c.commands)
			com.compileI(f)
	}
	
	def compileI(Command c, DefFunction f){
		var res = ""
		if (c.nop !== null)
			f.addCodeI("NOP", "", "", "")	
		else if (c.exprIf !== null){
			var siVrai = Main.newLab
			var siFaux = Main.newLab
			var fi = ""
			c.exprIf.compileI(f,siVrai,siFaux,true,false)
			f.addCodeI("LABEL "+siVrai,"","","")
			c.comIf.compileI(f)
			if (c.comElse !== null){
				fi = Main.newLab
				f.addCodeI("GOTO "+fi,"","","")
			}
			f.addCodeI("LABEL "+siFaux,"","","")
			if (c.comElse !== null){
				c.comElse.compileI(f)
				f.addCodeI("LABEL "+fi,"","","");
			}
		}
		else if (c.exprWhile !== null){
			var siVrai = Main.newLab
			var siFaux = Main.newLab
			var boucle = Main.newLab
			f.addCodeI("LABEL "+boucle,"","","");
			c.exprWhile.compileI(f,siVrai,siFaux,true,false)
			f.addCodeI("LABEL "+siVrai,"","","");
			c.comWhile.compileI(f)
			f.addCodeI("GOTO "+boucle,"","","")
			f.addCodeI("LABEL "+siFaux,"","","");
			
		}
		else if (c.exprFor !== null){
			var boucle = Main.newLab
			var forBody = Main.newLab
			var od = Main.newLab
			var nbBoucles = f.newVar
			f.addCodeI("WRITE","",c.exprFor.compileI(f,"","",false,false),"")
			f.addCodeI("READ",nbBoucles,"","")	
			f.addCodeI("LABEL "+boucle,"","","");
			f.addCodeI("IFNZ "+forBody,"",nbBoucles,"")
			f.addCodeI("GOTO "+od+"","","","")
			f.addCodeI("LABEL "+forBody,"","","");
			f.addCodeI("TAIL",nbBoucles,nbBoucles,"")
			c.comFor.compileI(f)
			f.addCodeI("GOTO "+boucle,"","","")
			f.addCodeI("LABEL "+od,"","","")	
		}
		else if (c.exprForeach !== null){
			var boucle = Main.newLab
			var forBody = Main.newLab
			var od = Main.newLab
			var nbBoucles = f.newVar
			var varForeach = f.newVar(c.varForeach)
			f.addCodeI("WRITE","",c.exprForeach.compileI(f,"","",false,false),"")
			f.addCodeI("READ",nbBoucles,"","")	
			f.addCodeI("LABEL "+boucle,"","","");
			f.addCodeI("IFNZ "+forBody,"",nbBoucles,"")
			f.addCodeI("GOTO "+od+"","","","")
			f.addCodeI("LABEL "+forBody,"","","");
			f.addCodeI("HEAD",varForeach,nbBoucles,"")
			f.addCodeI("TAIL",nbBoucles,nbBoucles,"")
			c.comForeach.compileI(f)
			f.addCodeI("GOTO "+boucle,"","","")
			f.addCodeI("LABEL "+od,"","","")	
		}		
		else{
			var expressions = new ArrayList<String>()
			for (var i = 0; i < c.exprs.size; i++){ 
				 res = c.exprs.get(i).compileI(f,"","",false,true)
				 expressions.add(res)
			}
			try {
				if (c.vars.size != Integer.parseInt(res)){
					System.err.println("Erreur de typage : pas le même nombre d'expressions à gauche et à droite d'une affectation.");
					System.exit(1);	
				}
			} catch (Exception exception) {
				if (c.vars.size != c.exprs.size){
					System.err.println("Erreur de typage : pas le même nombre d'expressions à gauche et à droite d'une affectation.");
					System.exit(1)
				}
				for (e : expressions)
					f.addCodeI("WRITE","",e,"")
			}
			for (var i = 0; i < c.vars.size; i++) 
				f.addCodeI("READ",f.newVar(c.vars.get(i)),"","")
		}
	}
	
	def String compileI(Expr c, DefFunction f, String siV, String siF, boolean boolExpr, boolean affectation){
		var expressions = c.exprsOr
		var nbAnd = expressions.size
		var res = ""
		if (nbAnd == 1)
			res = expressions.get(nbAnd-1).compileI(f, siV, siF,boolExpr,affectation)
		else {
			var siVrai = ""
			var siFaux = siF
			if (!boolExpr)
				siFaux = Main.newLab
			for(var i = 0; i < nbAnd - 1; i++){
				siVrai = Main.newLab
				expressions.get(i).compileI(f, siVrai, siFaux,true,false)
				f.addCodeI("LABEL "+siVrai,"","","")
			}
			siVrai = siV
			if (!boolExpr)
				siVrai = Main.newLab
			expressions.get(nbAnd-1).compileI(f, siVrai, siFaux,true,false)
			if (!boolExpr)
				res = codeIsVsF(f,siVrai,siFaux)
		}
		res
	}
	
	def compileI(ExprOr c, DefFunction f, String siV, String siF, boolean boolExpr,boolean affectation){
		var expressions = c.exprsNot
		var nbOr = expressions.size
		var res = ""
		if (nbOr == 1)
			res = expressions.get(nbOr-1).compileI(f, siV, siF,boolExpr,affectation)
		else {
			var siVrai = siV
			var siFaux = ""
			if (!boolExpr)
				siVrai = Main.newLab
			for(var i = 0; i < nbOr - 1; i++){
				siFaux = Main.newLab
				expressions.get(i).compileI(f, siVrai, siFaux,true,false)
				f.addCodeI("LABEL "+siFaux,"","","")
			}
			siFaux = siF
			if (!boolExpr)
				siFaux = Main.newLab
			expressions.get(nbOr-1).compileI(f, siVrai, siFaux,true,false)
			if (!boolExpr)
				res = codeIsVsF(f,siVrai,siFaux)
		}
		res
	}
	
	def compileI(ExprNot c, DefFunction f, String siV, String siF, boolean boolExpr, boolean affectation){
		var res = ""
		var siVrai = siV
		var siFaux = siF
		if (c.not === null)
			res = c.exprEq.compileI(f, siVrai, siFaux,boolExpr,affectation)
		else{
			if (!boolExpr){
				siVrai = Main.newLab
				siFaux = Main.newLab
			}
			res = c.exprEq.compileI(f, siFaux, siVrai,true,false)
			if (!boolExpr)
				res = codeIsVsF(f,siVrai,siFaux)
		}
		res
	}
	
	def compileI(ExprEq e, DefFunction f, String siV, String siF, boolean boolExpr, boolean affectation){
		var res = ""
		var siVrai = siV
		var siFaux = siF
		var sizeExpr = e.exprsSimple.size 
		if (sizeExpr == 0)
			res = e.expr.compileI(f,siVrai,siFaux,boolExpr,affectation)
		else if (sizeExpr == 1)
			res = e.exprsSimple.get(0).compileI(f,siVrai,siFaux,boolExpr,affectation)
		else{
			if (!boolExpr){
				siVrai = Main.newLab
				siFaux = Main.newLab
			}
			res = e.exprsSimple.get(0).compileI(f,siVrai,siFaux,false,false)
			var varIntermediaire = e.exprsSimple.get(1).compileI(f,siVrai,siFaux,false,false)
			f.addCodeI("IFNEQ "+siFaux,"",res,varIntermediaire)
			f.addCodeI("GOTO "+siVrai,"","","")
			if (!boolExpr)
				res = codeIsVsF(f,siVrai,siFaux)
		}
		res
	}
	
	def compileI(ExprSimple e, DefFunction f, String siV, String siF, boolean boolExpr, boolean affectation){
		var res = ""
		if (e.nil !== null){
			if (boolExpr)
				f.addCodeI("GOTO "+siF,"","","")
			else
				res = f.newVar
		}
		else if (e.symb !== null){
			res = f.newVar
			f.addCodeI("SYMB "+Main.newSymb(e.symb),res,"","")
		}
		else if (e.variable !== null){
			res = f.getVar(e.variable)
			if (boolExpr){
				if (res !== null)
					f.addCodeI("IFNZ "+siV,"",res,"")
				f.addCodeI("GOTO "+siF,"","","")
			}
			else if (res === null)
				res = f.newVar(e.variable)
		}
		else {
			if (e.LExprCons !== null)
				res = consListCodeI(e.LExprCons.exprs, f, false)
			else if (e.LExprList !== null)
				res = consListCodeI(e.LExprList.exprs, f, true)
			else if (e.exprHd !== null){
				res = f.newVar
				f.addCodeI("HEAD", res, e.exprHd.compileI(f,"","",false,false), "")
			}
			else if (e.exprTl !== null){
				res = f.newVar
				f.addCodeI("TAIL", res, e.exprTl.compileI(f,"","",false,false), "")
			}
			else if(e.function !== null){
				if (!Main.fonctions.containsKey(e.function)){
					System.err.println("La fonction " + e.function + " n'est pas définie !");
					System.exit(1);
				}
				var fonctionCalled = Main.fonctions.get(e.function)
				if (e.params.exprs.size != fonctionCalled.getNbInput){
						System.err.println("Erreur de typage : pas le bon nombre d'arguments passés à la fonction " + e.function + ".");
						System.exit(1);
				}
				if (!affectation && fonctionCalled.getNbOutput != 1){
					System.err.println("Erreur de typage : la fonction " + e.function + " devrait retourner exactement une variable.");
					System.exit(1);
				}
				for (p : e.params.exprs)
					f.addCodeI("WRITE","",p.compileI(f,"","",false,false),"")
				f.addCodeI("CALL "+fonctionCalled.getName,"","","")
				res = "" + fonctionCalled.getNbOutput
				if (!affectation){
					res = f.newVar
					f.addCodeI("READ",res,"","")
				}				
			}
			if (boolExpr){
				f.addCodeI("IFNZ "+siV,"",res,"")
				f.addCodeI("GOTO "+siF,"","","")
			}
		}
		res
	}
	
	def consListCodeI(List<Expr> expressions, DefFunction f, boolean list){
		var res = ""
		var varIntermediaire = ""
		var nbCons = expressions.size
		if (list)
				res = f.newVar
		else {
			nbCons--
			res = expressions.get(nbCons).compileI(f,"","",false,false)
		}
		if (nbCons > 0){
			nbCons--
			varIntermediaire = res
			res = f.newVar
			f.addCodeI("CONS",res, expressions.get(nbCons).compileI(f,"","",false,false), varIntermediaire)
		}
		for (var i = nbCons; i > 0; i--)
			f.addCodeI("CONS",res, expressions.get(i-1).compileI(f,"","",false,false), res)
		res
	}
	
	def codeIsVsF(DefFunction f, String siVrai, String siFaux){
		var res = f.newVar
		var fin = Main.newLab
		f.addCodeI("LABEL "+siVrai,"","","")
		f.addCodeI("TRUE",res,"","")
		f.addCodeI("GOTO "+fin,"","","")
		f.addCodeI("LABEL "+siFaux,"","","")
		f.addCodeI("LABEL "+fin,"","","")
		res
	}
}