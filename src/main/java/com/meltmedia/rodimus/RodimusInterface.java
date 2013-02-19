package com.meltmedia.rodimus;

import java.io.File;
import java.util.List;
import com.lexicalscope.jewel.cli.CommandLineInterface;
import com.lexicalscope.jewel.cli.Option;
import com.lexicalscope.jewel.cli.Unparsed;

@CommandLineInterface(application="rodimus")
public interface RodimusInterface {
  @Option(description="display this help and exit")
  boolean isHelp();
  
  @Option(shortName="v", description="verbose output")
  boolean isVerbose();
  
  @Unparsed(name="FILE")
  List<File> getFiles();
}
