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

import java.io.IOException;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.DTDHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.ext.DefaultHandler2;
import org.xml.sax.ext.LexicalHandler;

public class IdentityHandler
  implements ContentHandler, DTDHandler, LexicalHandler
{
  public static DefaultHandler2 EVENT_SINK = new DefaultHandler2();
  
  protected ContentHandler contentHandler;
  protected LexicalHandler lexicalHnadler;
  protected DTDHandler dtdHandler;
  
  public void setContentHandler( ContentHandler contentHandler ) {
    this.contentHandler = contentHandler;
    this.lexicalHnadler = contentHandler instanceof LexicalHandler ? (LexicalHandler)contentHandler : EVENT_SINK;
    this.dtdHandler = contentHandler instanceof DTDHandler ? (DTDHandler)dtdHandler : EVENT_SINK;
  }
  
  public void setDocumentLocator(Locator locator) {
    contentHandler.setDocumentLocator(locator);
  }
  public void startDocument() throws SAXException {
    contentHandler.startDocument();
  }
  public void endDocument() throws SAXException {
    contentHandler.endDocument();
  }
  public void startPrefixMapping(String prefix, String uri) throws SAXException {
    contentHandler.startPrefixMapping(prefix, uri);
  }
  public void endPrefixMapping(String prefix) throws SAXException {
    contentHandler.endPrefixMapping(prefix);
  }
  public void startElement(String uri, String localName, String qName,
      Attributes atts) throws SAXException {
    contentHandler.startElement(uri, localName, qName, atts);
  }
  public void endElement(String uri, String localName, String qName)
      throws SAXException {
    contentHandler.endElement(uri, localName, qName);
  }
  public void characters(char[] ch, int start, int length) throws SAXException {
    contentHandler.characters(ch, start, length);
  }
  public void ignorableWhitespace(char[] ch, int start, int length)
      throws SAXException {
    contentHandler.ignorableWhitespace(ch, start, length);
  }
  public void processingInstruction(String target, String data)
      throws SAXException {
    contentHandler.processingInstruction(target, data);
  }
  public void skippedEntity(String name) throws SAXException {
    contentHandler.skippedEntity(name);
  }
  public void startDTD(String name, String publicId, String systemId)
      throws SAXException {
    lexicalHnadler.startDTD(name, publicId, systemId);
  }
  public void endDTD() throws SAXException {
    lexicalHnadler.endDTD();
  }
  public void startEntity(String name) throws SAXException {
    lexicalHnadler.startEntity(name);
  }
  public void endEntity(String name) throws SAXException {
    lexicalHnadler.endEntity(name);
  }
  public void startCDATA() throws SAXException {
    lexicalHnadler.startCDATA();
  }
  public void endCDATA() throws SAXException {
    lexicalHnadler.endCDATA();
  }
  public void comment(char[] ch, int start, int length) throws SAXException {
    lexicalHnadler.comment(ch, start, length);
  }
  public void notationDecl(String name, String publicId, String systemId)
      throws SAXException {
    dtdHandler.notationDecl(name, publicId, systemId);
  }
  public void unparsedEntityDecl(String name, String publicId, String systemId,
      String notationName) throws SAXException {
    dtdHandler.unparsedEntityDecl(name, publicId, systemId, notationName);
  }
}
