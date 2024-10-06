package cll;

public class App {
    static {
        System.loadLibrary("cll");
    }

    // Declare the native methods
    public native String greet(String name);
    public native String fibonacci(String n);
    public native void freeGreeting(String greeting);
    public native void freeResult(String result);

    public static void main(String[] args) {
        App wrapper = new App();

        String name = "From Java Lib!\nHope you are doing good.";
        String greeting = wrapper.greet(name);
        System.out.println(greeting);

        int n = 10;
        String fibResult = wrapper.fibonacci(String.valueOf(n));
        System.out.printf("Fibonacci of %d: %s\n", n, fibResult);
    }
}
