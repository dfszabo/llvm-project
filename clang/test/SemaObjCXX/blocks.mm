// RUN: clang -fsyntax-only -verify -fblocks %s
@protocol NSObject;

void bar(id(^)(void));
void foo(id <NSObject>(^objectCreationBlock)(void)) {
    return bar(objectCreationBlock); // expected-warning{{incompatible pointer types passing 'id (^)(void)', expected 'id<NSObject> (^)(void)'}}
}

void bar2(id(*)(void));
void foo2(id <NSObject>(*objectCreationBlock)(void)) {
    return bar2(objectCreationBlock); // expected-warning{{incompatible pointer types passing 'id (*)(void)', expected 'id<NSObject> (*)(void)'}}
}

void bar3(id(*)()); // expected-note{{candidate function}}
void foo3(id (*objectCreationBlock)(int)) {
    return bar3(objectCreationBlock); // expected-error{{no matching}}
}

void bar4(id(^)()); // expected-note{{candidate function}}
void foo4(id (^objectCreationBlock)(int)) {
    return bar4(objectCreationBlock); // expected-error{{no matching}}
}

void foo5(id (^x)(int)) {
  if (x) { }
}
