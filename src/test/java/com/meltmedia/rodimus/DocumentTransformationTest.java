package com.meltmedia.rodimus;

import java.io.File;
import java.io.FileFilter;
import java.io.FileReader;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import com.cloudbees.diff.Diff;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class DocumentTransformationTest {
  
  private static File actualsDir;

  @BeforeClass
  public static void prepareTest() {
    actualsDir = new File("target/testTransforms");
    actualsDir.mkdirs();
  }
  
  private File document;
  private File expectedOutputDir;
  private File actualOutputDir;

  public DocumentTransformationTest( File document, File expectedOutputDir ) {
    this.document = document;
    this.expectedOutputDir = expectedOutputDir;
    this.actualOutputDir = new File(actualsDir, document.getName().replaceFirst("\\A(.*)\\.docx\\Z", "$1"));
  }
  
  @Before
  public void beforeTest() throws Exception {
    // clear out the output directory.
    FileUtils.deleteQuietly(actualOutputDir);
    if(!actualOutputDir.mkdir()) {
      fail("Could not create output directory for "+document.getPath());
    }
    
    // rerun the transform.
    RodimusCli.transformDocument(document, actualOutputDir, false);
  }
  
  @Test
  public void diffWithWhitespace() throws IOException {
    for( File expectedHtmlFile : expectedOutputDir.listFiles(new FileFilter() { @Override public boolean accept(File pathname) { return pathname.isFile(); } }) ) {
      File actualHtmlFile = new File(actualOutputDir, expectedHtmlFile.getName());
      
      Diff diff = Diff.diff(expectedHtmlFile, actualHtmlFile, false);
      
      if( !diff.isEmpty() ) {
        // build up the output.
        fail(diff.toUnifiedDiff("expected", "actual", new FileReader(expectedHtmlFile), new FileReader(actualHtmlFile), 3));
      }
    }
  }
  
  @Test 
  public void diffWithOutWhitespace() throws IOException {
    for( File expectedHtmlFile : expectedOutputDir.listFiles(new FileFilter() { @Override public boolean accept(File pathname) { return pathname.isFile(); } }) ) {
      File actualHtmlFile = new File(actualOutputDir, expectedHtmlFile.getName());
      
      Diff diff = Diff.diff(expectedHtmlFile, actualHtmlFile, true);
      
      if( !diff.isEmpty() ) {
        // build up the output.
        fail(diff.toUnifiedDiff("expected", "actual", new FileReader(expectedHtmlFile), new FileReader(actualHtmlFile), 3));
      }
    }    
  }
  
  @Test
  public void compareAssets() throws IOException {
    File expectedImages = new File(expectedOutputDir, "img");
    File actualImages = new File(actualOutputDir, "img");
    
    for( File expected : expectedImages.listFiles(new FileFilter() { @Override public boolean accept(File pathname) { return pathname.isFile(); } }) ) {
      File actual = new File(actualImages, expected.getName());
      if( !actual.exists() && actual.isFile()) {
        fail("The file "+actual+" does not exist, or is not a file.");
      }
      if( !FileUtils.contentEquals(expected, actual)) {
        fail("The content in "+actual+" is different than "+expected);
      }
    }
  }
  
  @Parameters
  public static Collection<Object[]> parameters() throws URISyntaxException {
    List<Object[]> fileComparisons = new ArrayList<Object[]>();
    
    URL testRoot = DocumentTransformationTest.class.getClassLoader().getResource("testCases");
    File testCaseDir = new File(testRoot.toURI());
    
    for( File docFile : testCaseDir.listFiles(new FileFilter() {
      @Override public boolean accept(File pathname) { return pathname.getName().matches(".*\\.docx"); }
    }) ) {
      File expectedDir = new File(testCaseDir, docFile.getName().replaceFirst("\\A(.*)\\.docx\\Z", "$1"));
      fileComparisons.add(new Object[] { docFile, expectedDir });
    }
    
    return fileComparisons;
  }
}
