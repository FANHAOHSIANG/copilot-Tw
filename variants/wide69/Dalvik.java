import brut.androlib.mod.SmaliMod;
import com.android.tools.smali.baksmali.Baksmali;
import com.android.tools.smali.baksmali.BaksmaliOptions;
import com.android.tools.smali.dexlib2.DexFileFactory;
import com.android.tools.smali.dexlib2.Opcodes;
import com.android.tools.smali.dexlib2.writer.builder.DexBuilder;
import com.android.tools.smali.dexlib2.writer.io.FileDataStore;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;

class Dalvik {
    public static void main(String[] args) throws Exception {
        Path input = Path.of(args[1]);
        File output = new File(args[2]);
        var opcodes = new Opcodes(31, -1);
        switch (args[0]) {
            case "decode" -> {
                var container = DexFileFactory.loadDexContainer(input.toFile(), opcodes);
                var options = new BaksmaliOptions();
                options.localsDirective = true;
                options.debugInfo = true;
                Baksmali.disassembleDexFile(container.getEntry((String) container.getDexEntryNames().getFirst()).getDexFile(),
                        output, Runtime.getRuntime().availableProcessors(), options);
            }
            case "assemble" -> {
                var dex = new DexBuilder(opcodes);
                try (var paths = Files.walk(input)) {
                    for (Path path : paths.filter(p -> p.toString().endsWith(".smali")).sorted().toList()) {
                        if (!SmaliMod.assembleSmaliFile(path.toFile(), dex, 31)) {
                            throw new IllegalStateException("Invalid smali: " + path);
                        }
                    }
                }
                dex.writeTo(new FileDataStore(output));
            }
            default -> throw new IllegalArgumentException(args[0]);
        }
    }
}
