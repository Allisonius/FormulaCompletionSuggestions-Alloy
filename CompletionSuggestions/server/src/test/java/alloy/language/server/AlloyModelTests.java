package alloy.language.server;

import edu.mit.csail.sdg.alloy4.A4Reporter;
import edu.mit.csail.sdg.alloy4.ErrorWarning;
import edu.mit.csail.sdg.ast.Command;
import edu.mit.csail.sdg.ast.Func;
import edu.mit.csail.sdg.ast.Sig;
import edu.mit.csail.sdg.parser.CompModule;
import edu.mit.csail.sdg.parser.CompUtil;
import edu.mit.csail.sdg.translator.A4Options;
import edu.mit.csail.sdg.translator.A4Solution;
import edu.mit.csail.sdg.translator.A4TupleSet;
import edu.mit.csail.sdg.translator.TranslateAlloyToKodkod;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AlloyModelTests {

    private final A4Reporter rep = new A4Reporter() {
        @Override
        public void warning(ErrorWarning msg) {
            System.out.println(msg.toString().trim());
            System.out.flush();
        }
    };

    // @Test
    void testModelFromFile() {
        String file_name = "usage/classroom_fol.als";
        // This reads in the Alloy model, parses it and then stores it as a CompModule
        // Which basically is an object interpretation of the model that we can work
        // with to do things like iterate over commands in the model and run them
        CompModule world = CompUtil.parseEverything_fromFile(rep, null, file_name);
        var sigs = world.getAllSigs();
        for (var sig : sigs) {
            System.out.println(sig);
            System.out.println(sig.type());
        }

        System.out.println(world.explain());
        System.out.println(world.getAllFunc());
        System.out.println(world.pos());
    }

    private String demo() {
        return  String.join("\n",
                "sig Person {}",
                "sig Student in Person {}",
                "sig Teacher in Person {" +
                        "teaches: Student" +
                        "}",
                "sig Group {}",
                "sig Class { Groups: Person -> Group }",
                "fact {",
                "    all x: Person | x in Student or x in Teacher",
                "}",
                "pred show {}",
                "run show for 3"
        );
    }

    @Test
    void testFinishedModel() throws IOException {
        String alloyCode = demo();
        CompModule world = CompUtil.parseEverything_fromString(rep, alloyCode);

        var sigs = world.getAllSigs();
        List<Sig.Field> fields = new ArrayList<>();
        for (var sig : sigs) {
            fields.addAll(sig.getFields().makeCopy());
        }

        System.out.println(sigs);
        System.out.println(fields);


        for (Func predicate : world.getAllFunc()) {
            System.out.println(predicate.getBody());
        }

        // Case in point, we can get the list of all commands written in the model. This
        // runs the first command
        int cmdNum = 0;
        Command command = world.getAllCommands().get(cmdNum);

        // These options configure "how" to run a command - what solver to use, what is
        // the max memory the execution can use, etc
        // We usually just set it up in a very bare bones format - i.e. just set the SAT
        // solver then use the default for everything else
        A4Options options = new A4Options();
        options.solver = A4Options.SatSolver.SAT4J;

        // Runs first command, stores the result
        A4Solution instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), command,
                options);

        var atoms = instance.getAllAtoms();
        var skolems = instance.getAllSkolems();
        for (var atom : atoms) {
            System.out.println(atom);
            System.out.println(atom.type());
        }

        System.out.println("Checking if the first atom is in the set of all atoms");
        var firstAtom = atoms.iterator().next();
        System.out.println(firstAtom);
        System.out.println(firstAtom.type());
        for (var atom : atoms) {
            var arrowExpr = firstAtom.lone_arrow_any(atom);
            System.out.println(arrowExpr);
            System.out.println(instance.eval(firstAtom.in(atom)));
        }

        System.out.println(instance.getAllReachableSigs());
        System.out.println(instance.getAllAtoms());
        System.out.println(instance.format(1));
        for(var skolem : skolems) {
            System.out.println(skolem);
        }
    }

    @Test
    void testAtomAndRelations() throws IOException {
        String alloyCode = demo();
        CompModule world = CompUtil.parseEverything_fromString(rep, alloyCode);
//        world.addDefaultCommand();
        int cmdNum = 0;
        Command command = world.getAllCommands().get(cmdNum);
        System.out.println(command);

        A4Options options = new A4Options();
        options.solver = A4Options.SatSolver.SAT4J;

        // Runs first command, stores the result
        A4Solution instance = TranslateAlloyToKodkod.execute_command(rep, world.getAllReachableSigs(), command,
                options);

        var sigs = world.getAllSigs();
        System.out.println("Sigs: " + sigs);

        var atoms = instance.getAllAtoms();
        System.out.println("Atoms: " + atoms);
        for (var atom : atoms) {
            System.out.println(atom + " " + atom.type());
        }

        System.out.println("Checking if the first atom is in the set of all atoms");
        if (!atoms.iterator().hasNext()){
            System.out.println("No atoms found");
            return;
        }
        var firstAtom = atoms.iterator().next();
        if (firstAtom == null) {
            System.out.println("First atom is null");
            return;
        }
        System.out.println(firstAtom);
        System.out.println(firstAtom.type());
        for (var atom : atoms) {
            System.out.println(instance.eval(firstAtom.in(atom)));
        }

        System.out.println("All tuples");
        Map<String, A4TupleSet> tuples = new HashMap<>();
        for (var sig : sigs) {
            System.out.println(sig.label);
            tuples.put(sig.label, instance.eval(sig));
            for (var field : sig.getFields()) {
                System.out.println(field.label);
                tuples.put(field.label, instance.eval(field));
            }
        }

        System.out.println(tuples);
    }
}
