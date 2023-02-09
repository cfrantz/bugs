#![feature(min_specialization)]
use std::any::TypeId;
use serde::Serialize;

use greeting::Greeting;

#[derive(Default, Debug, Serialize)]
struct Foo {
    x: u32,
}

impl Greeting for Foo {
    fn id(&self) -> Option<TypeId> {
        Some(TypeId::of::<Foo>())
    }
}

fn main() {
    let foo = Foo::default();
    println!("case1");
    println!("Foo greeting: {}", foo.greet());
    println!("Foo id: {:?}", foo.id());
}
