package cpl;

public class App {
    static {
        System.loadLibrary("cpl");
    }

    // Declare the native method
    public native String greet(String name);

    // Wrapper method to free the memory allocated by the Rust library
    public native void freeGreeting(String greeting);

    public static void main(String[] args) {
        App wrapper = new App();
        String name = "Alice";
        String greeting = wrapper.greet(name);
        System.out.println(greeting);
        wrapper.freeGreeting(greeting);
    }
}
