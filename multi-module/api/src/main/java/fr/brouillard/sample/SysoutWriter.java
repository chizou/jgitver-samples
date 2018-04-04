package fr.brouillard.sample;

import fr.brouillard.sample.api.Writer;

public class SysoutWriter implements Writer {
    public void write(String s) {
        System.out.println(s);
    }
}
