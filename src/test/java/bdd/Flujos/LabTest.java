package bdd.Flujos;

import com.intuit.karate.junit5.Karate;

class LabTest {

    @Karate.Test
    Karate testAll() {
        // Corre todo lo que encuentre o lo que le ordenes por consola/IntelliJ
        return Karate.run().relativeTo(getClass());
    }
}