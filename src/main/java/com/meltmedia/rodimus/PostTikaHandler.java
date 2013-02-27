/**
 *    Copyright 2013 meltmedia
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
package com.meltmedia.rodimus;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

public class PostTikaHandler
  extends IdentityHandler
{
  public static final String IMAGE_TAG = "img";
  public static final String SRC_ATTR = "src";
  public static final String XHTML_NAMESPACE = "http://www.w3.org/1999/xhtml";
  
  public String imageDirName;
  
  public PostTikaHandler( String imageDirName ) {
    this.imageDirName = imageDirName;
  }
  
  @Override
  public void startElement(String uri, String localName, String qName, Attributes atts) throws SAXException {
    if( XHTML_NAMESPACE.equals(uri) && IMAGE_TAG.equalsIgnoreCase(localName) ) {
      AttributesImpl newAtts = new AttributesImpl(atts);
      int srcIndex = newAtts.getIndex(SRC_ATTR);
      if( srcIndex > -1 ) newAtts.setValue(srcIndex, newAtts.getValue(srcIndex).replaceFirst("\\Aembedded\\:", imageDirName+"/"));
      this.contentHandler.startElement(uri, localName, qName, newAtts);
    }
    else {
      super.startElement(uri, localName, qName, atts);
    }
  }
}
