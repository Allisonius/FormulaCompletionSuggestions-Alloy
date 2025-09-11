package arepair.generator.util;

import arepair.generator.etc.Card;
import arepair.generator.fragment.Type;
import parser.ast.nodes.*;

import java.util.List;
import java.util.stream.Collectors;

import static parser.etc.Names.COMMA;

public class TypeInfo {

  Node node;
  String name;
  String uid;
  int arity;
  boolean hasIden;
  List<Type> types;
  List<Card> cards;

  private TypeInfo(Node node, int arity, boolean hasIden, List<Type> types, List<Card> cards) {
    this.node = node;
    if (node instanceof SigDecl) {
      name = ((SigDecl) node).getName();
    } else if (node instanceof FieldExpr) {
      name = ((FieldExpr) node).getName();
    } else if (node instanceof VarExpr) {
      VarExpr var = (VarExpr) node;
      name = var.getName();
    } else if (node instanceof ConstExpr) {
      name = ((ConstExpr) node).getValue();
    } else {
      throw new RuntimeException("Unsupported type information");
    }
    this.uid = name;
    this.arity = arity;
    this.hasIden = hasIden;
    this.types = types;
    this.cards = cards;
  }

  private TypeInfo(String name, String uid, int arity, boolean hasIden, List<Type> types, List<Card> cards) {
    this.name = name;
    this.uid = uid;
    this.arity = arity;
    this.hasIden = hasIden;
    this.types = types;
    this.cards = cards;
  }

  public static TypeInfo of(Node node, TypeInfo typeInfo) {
    return new TypeInfo(node, typeInfo.arity, typeInfo.hasIden, typeInfo.types, typeInfo.cards);
  }

  public static TypeInfo of(int arity, boolean hasIden, List<Type> types, List<Card> cards) {
    return of(null, null, arity, hasIden, types, cards);
  }

  public static TypeInfo of(Node node, int arity, boolean hasIden, List<Type> types,
      List<Card> cards) {
    return new TypeInfo(node, arity, hasIden, types, cards);
  }

  public static TypeInfo of(String name, String uid, int arity, boolean hasIden,
      List<Type> types, List<Card> cards) {
      return new TypeInfo(name, uid, arity, hasIden, types, cards);
  }

  public Node getNode() {
    return node;
  }

  public int getArity() {
    return arity;
  }

  public boolean isHasIden() {
    return hasIden;
  }

  public List<Type> getTypes() {
    return types;
  }

  public List<Card> getCards() {
    return cards;
  }

  public String getTypeAsString() {
    return String.join(COMMA, types.stream().map(Type::getPruneType).collect(Collectors.toList()));
  }

  public String getName() {
    return name;
  }

  public String getUid() {
    return uid;
  }

  @Override
  public String toString() {
    return "<" +
            "name: " + name +
            ", uid: " + uid +
            ", arity: " + arity +
            ", hasIden: " + hasIden +
            ", types: " + types +
            ", cards: " + cards +
            ">";
  }
}
