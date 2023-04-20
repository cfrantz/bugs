use cryptoki::session::Pkcs11;

fn main() {
    let module = "/usr/lib/x86_64-linux-gnu/softhsm/libsofthsm2.so";
    let pkcs11 = Pkcs11::new(module).unwrap();
    println!("pkcs11 = {:?}", pkcs11);
}
