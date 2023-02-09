#![feature(min_specialization)]
use std::any::TypeId;
use serde::Serialize;

pub trait Greeting {
    fn greet(&self) -> String;
    fn id(&self) -> Option<TypeId>;
}

impl<T: Serialize> Greeting for T {
    default fn greet(&self) -> String {
        "hello".into()
    }
    default fn id(&self) -> Option<TypeId> {
        None
    }
}
