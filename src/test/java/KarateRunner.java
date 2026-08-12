import com.intuit.karate.junit5.Karate;

public class KarateRunner {
    /*
    @Karate.Test
    Karate testAll(){
        return Karate.run("classpath:bdd/Flujos/Regresion.feature").relativeTo(getClass());
    }*/

    @Karate.Test /**prueba de commit */
    Karate testAll() {
        // Apunta al nuevo feature, no al que tiene @ignore
        return Karate.run("classpath:bdd/Flujos/Transferencia.feature");
    }
}