package arepair.generator;

import alloy.language.server.utils.AlloyEvaluation;
import alloy.language.server.utils.CodeUtils;
import arepair.generator.etc.Card;
import arepair.generator.fragment.Expression;
import arepair.generator.fragment.Fragment;
import arepair.generator.fragment.Type;
import arepair.generator.util.TypeInfo;
import arepair.generator.util.Util;
import edu.mit.csail.sdg.ast.Sig;
import edu.mit.csail.sdg.parser.CompModule;
import org.eclipse.lsp4j.CompletionItem;
import org.eclipse.lsp4j.CompletionItemKind;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Stream;

import static arepair.generator.util.Util.createType;
import static arepair.generator.util.Util.findCardinality;

public class CompatUtils {

	public static List<TypeInfo> populateTypeInfos(List<Sig> signatures) {
		List<TypeInfo> basicTypes = new LinkedList<>();
		for (var sig : signatures) {
			if (sig.label.equals("seq/Int")) continue;
			// Collect a list of Type objects from the sig's type
			basicTypes.add(createTypeInfo(sig));

			for (var field : sig.getFields()) {
				// Add the field type as well
				basicTypes.add(createTypeInfo(field));
			}
		}
		return basicTypes;
	}

	public static List<Type> typeAsList(edu.mit.csail.sdg.ast.Type type) {
		return type.fold()
		           .stream()
		           .flatMap(Collection::stream)
		           .map(t -> createType(CodeUtils.formatLabel(t)))
		           .toList();
	}

	public static TypeInfo createTypeInfo(String label) {
		List<Type> types = List.of(createType(label));
		List<Card> cards = List.of(Card.SET);
		return TypeInfo.of(label, label, 0, false, types, cards);
	}

	public static TypeInfo createTypeInfo(String label, edu.mit.csail.sdg.ast.Type type) {
		List<Type> types = typeAsList(type);
		List<Card> cards = type.fold().stream().flatMap(Collection::stream).map(Util::findCardinality).toList();
		return TypeInfo.of(label, label, type.arity(), false, types, cards);
	}

	public static TypeInfo createTypeInfo(Sig sig) {
		List<Type> types = typeAsList(sig.type());
		List<Card> cards = List.of(findCardinality(sig));

		return TypeInfo.of(CodeUtils.formatLabel(sig), CodeUtils.formatLabel(sig), sig.type().arity(), false, types,
		                   cards);
	}

	public static TypeInfo createTypeInfo(Sig.Field field) {
		List<Type> fieldTypes = typeAsList(field.type());
		List<Card> fieldCardinality =
				field.type().fold().stream().flatMap(Collection::stream).map(Util::findCardinality).toList();
		return TypeInfo.of(CodeUtils.formatLabel(field), CodeUtils.formatLabel(field), field.type().arity(), false,
		                   fieldTypes, fieldCardinality);
	}

	public static Expression createExpression(Sig sig) {
		var typeInfo = createTypeInfo(sig);
		return Util.createExprFromType(typeInfo);
	}

	public static Expression createExpression(Sig.Field field) {
		var typeInfo = createTypeInfo(field);
		return Util.createExprFromType(typeInfo);
	}

	public static Expression createExpression(String label, edu.mit.csail.sdg.ast.Type type) {
		var typeInfo = createTypeInfo(label, type);
		return Util.createExprFromType(typeInfo);
	}

	public static Expression buildExpression(String op, Expression expr) {
		return Util.buildExpression(1, new Fragment(op), expr);
	}

	public static List<TypeInfo> populateTypeInfos(Map<String, edu.mit.csail.sdg.ast.Type> quantifierMap) {
		return quantifierMap.entrySet().stream().map(entry -> {
			String label = entry.getKey();
			var type = entry.getValue();
			return createTypeInfo(label, type);
		}).toList();
	}

	public static CompletionItem completionItemFromExpression(Expression expression) {
		CompletionItem item = new CompletionItem();
		String label = expression.getValue();
		item.setLabel(label);
		item.setDetail("Detail: " + label);
		item.setKind(CompletionItemKind.Class);
		item.setDocumentation(expression.toString());
		item.setSortText("");
		return item;
	}

	public static Map<String, String> buildInheritanceHierarchy(CompModule model) {
		Map<String, String> inheritanceHierarchy = new LinkedHashMap<>();
		for (var sigDecl : model.getAllSigs()) {
			if (sigDecl.isTopLevel()) {
				inheritanceHierarchy.put(CodeUtils.formatLabel(sigDecl), null);
			} else {
				String parent = CodeUtils.findParent(sigDecl.type());
				inheritanceHierarchy.put(CodeUtils.formatLabel(sigDecl), parent);
			}
		}
		return inheritanceHierarchy;
	}
}
