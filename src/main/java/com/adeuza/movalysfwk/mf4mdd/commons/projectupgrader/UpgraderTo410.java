/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.commons.projectupgrader;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;

import com.a2a.adjava.codeformatter.GeneratedFile;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.projectupgrader.AbstractProjectUpgrader;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;

/**
 * Upgrader for version 4.1.0
 * This upgrader deletes wrong nodes in PLIST files (new string format instead of bool format)
 * and updates the Framework-config.plist for iOS
 */
public class UpgraderTo410 extends AbstractProjectUpgrader {

	//MAP KEYS
	/** The logger used in this class */
	private static final Logger log = LoggerFactory.getLogger(UpgraderTo410.class);



	//PARAM KEYS
	/** The key used to get the generated context*/
	private final String PARAM_KEY_GENERATED_CONTEXT = "generatedContext";

	/** The key used to get the main project name */
	private final String PARAM_KEY_MAIN_PROJECT = "mainProject";

	//FRAMEWORK CONFIG FILE NODE KEYS
	/** The key used to identify a node with value containing "authorizedValue"*/
	private final String NODE_VALUE_OLD_AUTHORIZED_VALUE = "authorizedValue";

	/** The value to set in a node that had "authorizedValue" value*/
	private final String NODE_VALUE_NEW_RECOGNIZED_VALUE = "recognizedValues";

	/** The key used to identify a node with value matching "YES;NO"*/
	private final String NODE_VALUE_OLD_BOOL_VALUES = "YES;NO";

	/** The value to set in a node that had "YES;NO" value*/
	private final String NODE_VALUE_NEW_BOOL_VALUES = "YES;NO;1;0;true;false";


	//PATH
	/** The path to the Framework-config.plist file from the generated project */
	private final String PATH_TO_FRAMEWORK_CONFIG_FILE_FROM_PROJECT = "/resources/plist/Framework-config.plist";

	private HashMap<String, List<HashMap<String, Node>>> nodeFixesMap;


	@Override	
	/**
	 * ${inherited}
	 */
	public void executeFixesForAndroid(
			IDomain<IModelDictionary, IModelFactory> p_oDomain,
			Map<String, ?> p_oGlobalSession) throws Exception {

	}

	@Override
	/**
	 * ${inherited}
	 */
	public void executeFixesForIOS(
			IDomain<IModelDictionary, IModelFactory> p_oDomain,
			Map<String, ?> p_oGlobalSession) throws Exception {

		//Apply changes on generated files
		//		executeChangesOnGeneratedFiles(p_oGlobalSession);

		executeChangesOnPlistFiles(p_oGlobalSession);
		//Apply changes on Framework-config.plist
		executeChangesOnFrameworkConfigPlist(p_oDomain, p_oGlobalSession);

	}

	@SuppressWarnings("rawtypes")
	/**
	 * Apply changes on matching generated plist files
	 * @param p_oGlobalSession The global session
	 * @throws Exception Exception that can be throw during the global treatment of upgrader
	 */
	private void executeChangesOnPlistFiles(Map<String, ?> p_oGlobalSession) throws Exception {
		List<GeneratedFile> oGeneratedfiles = ((DomainGeneratorContext)(p_oGlobalSession.get(PARAM_KEY_GENERATED_CONTEXT))).getGeneratedFiles();
		for(GeneratedFile<?> oGeneratedfile : oGeneratedfiles ) {
			log.debug("UpgraderTo410#analizingFile : " + oGeneratedfile.getFileFromRoot().getCanonicalPath());
			if((oGeneratedfile.getFileFromRoot().getName().startsWith("section-") || oGeneratedfile.getFileFromRoot().getName().startsWith("form-"))
					&& oGeneratedfile.getFileFromRoot().getName().endsWith(".plist") 
					&& !oGeneratedfile.getFileFromRoot().getAbsolutePath().contains("mdkBackups")) {
				String sFileOriginalContent = readFile(oGeneratedfile.getFileFromRoot());
				String sFileModifiedContent = treatPlistFile(oGeneratedfile.getFileFromRoot(), sFileOriginalContent);
				if(!sFileModifiedContent.equals(sFileOriginalContent)) {
					writeFile(sFileModifiedContent, oGeneratedfile.getFileFromRoot());
				}
			}
		}
	}


	private void writeFile(String p_sContentToWrite, File p_oFileToWrite) throws IOException {
		FileUtils.writeStringToFile(p_oFileToWrite, p_sContentToWrite);
	}

	/**
	 * Treats a file that match the files that should be treated.
	 * @param p_oGeneratedfile A file that should be treat
	 * @throws Exception An exception that can be thrown during the treatment of file
	 */
	private String treatPlistFile(File p_oGeneratedfile, String p_sOriginalContent) throws Exception {
		boolean hasChanged = false;
		log.debug("UpgraderTo410#treatingFile : Treating file at location : " + p_oGeneratedfile.getAbsolutePath());
		p_sOriginalContent = treatDoubleBooleanValues(p_sOriginalContent);
		p_sOriginalContent = treatWrongBooleanValues(p_sOriginalContent);
		return p_sOriginalContent;
		
	}	


	private String treatDoubleBooleanValues(String sFileContent) {
		sFileContent = sFileContent.replaceAll("<true/><string>YES</string>", "<string>YES</string>");
		sFileContent = sFileContent.replaceAll("<true/><string>NO</string>", "<string>YES</string>");
		sFileContent = sFileContent.replaceAll("<false/><string>YES</string>", "<string>NO</string>");
		sFileContent = sFileContent.replaceAll("<false/><string>NO</string>", "<string>NO</string>");

		sFileContent = sFileContent.replaceAll("<string>YES</string><true/>", "<string>YES</string>");
		sFileContent = sFileContent.replaceAll("<string>NO</string><true/>", "<string>YES</string>");
		sFileContent = sFileContent.replaceAll("<string>YES</string><false/>", "<string>NO</string>");
		sFileContent = sFileContent.replaceAll("<string>NO</string><false/>", "<string>NO</string>");
		return sFileContent;
	}

	private String treatWrongBooleanValues(String sFileContent) {
		sFileContent = sFileContent.replaceAll("<key>visible</key><true/>", "<key>visible</key><string>YES</string>");
		sFileContent = sFileContent.replaceAll("<key>visible</key><false/>", "<key>visible</key><string>NO</string>");

		sFileContent = sFileContent.replaceAll("<key>editable</key><true/>", "<key>editable</key><string>YES</string>");
		sFileContent = sFileContent.replaceAll("<key>editable</key><false/>", "<key>editable</key><string>NO</string>");

		sFileContent = sFileContent.replaceAll("<key>mandatory</key><true/>", "<key>mandatory</key><string>YES</string>");
		sFileContent = sFileContent.replaceAll("<key>mandatory</key><false/>", "<key>mandatory</key><string>NO</string>");
		return sFileContent;
	}


	/**
	 * Execute changes on the Framework-config.plist file
	 * @param p_oDomain The domain used to do this upgrader (Android / iOS ...)
	 * @param p_oGlobalSession The global session used to do this upgrader
	 * @throws Exception An exception that can be thrown during the global treatment of upgrader
	 */
	private void executeChangesOnFrameworkConfigPlist(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		File oFrameworkConfigFile = new File(p_oDomain.getGlobalParameters().get(PARAM_KEY_MAIN_PROJECT)+PATH_TO_FRAMEWORK_CONFIG_FILE_FROM_PROJECT);
		treatFrameworkConfigFile(oFrameworkConfigFile);

	}



	/**
	 * Treats the Framework-config.plist file to update old values such as "authorizedValues"
	 * @param p_oFrameworkConfigFile the File object to treat
	 * @throws Exception An exception that can be thrown during the treatment of file
	 */
	private void treatFrameworkConfigFile(File p_oFrameworkConfigFile) throws Exception {
		Document doc = parseFileToXml(p_oFrameworkConfigFile);
		if(doc != null) {
			parseFrameworkConfigNode(doc);
		}		
		writeFile(doc, p_oFrameworkConfigFile);

	}

	/**
	 * Parse and maybe fix a node of Framework-conf.plist file
	 * @param p_oNode The node to parse and that could be potentially be fixed
	 */
	private void parseFrameworkConfigNode(Node p_oNode) {
		log.debug("UpgraderTo410#parseFrameworkConfigNode : Node STRING value is : "  + p_oNode.getNodeValue());

		if(p_oNode.hasChildNodes()) {
			NodeList nodeList = p_oNode.getChildNodes();
			for(int i = 0 ; i < nodeList.getLength() ; i++) {
				parseFrameworkConfigNode(nodeList.item(i));
			}
		}

		if(p_oNode.getNodeValue() != null && p_oNode.getNodeValue().contains(NODE_VALUE_OLD_AUTHORIZED_VALUE)) {
			p_oNode.setNodeValue(NODE_VALUE_NEW_RECOGNIZED_VALUE);
		} 
		else if(p_oNode.getNodeValue() != null && p_oNode.getNodeValue().equalsIgnoreCase(NODE_VALUE_OLD_BOOL_VALUES)) {
			p_oNode.setNodeValue(NODE_VALUE_NEW_BOOL_VALUES);
		}

	}


	/**
	 * Parses a given file to product a Document object
	 * @param p_oFileToProcess The file to parse
	 * @return A Document object built from the given file
	 * @throws Exception An Exception that can be thrown during the process
	 */
	private Document parseFileToXml(File p_oFileToProcess) throws Exception {
		if(!p_oFileToProcess.exists()) {
			log.debug("UpgraderTo410#parseFileToXml : Unable to find a file at location : \n" 
					+ p_oFileToProcess.getAbsolutePath());
			return null;
		}
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setIgnoringElementContentWhitespace(true);
		DocumentBuilder builder = factory.newDocumentBuilder();
		builder.setEntityResolver(new EntityResolver() {

			@Override
			public InputSource resolveEntity (String publicId, String systemId)
			{
				return new InputSource(new ByteArrayInputStream(new byte[]{}));

			}
		});
		Document doc = null;
		int count = 0;
		Exception exception = null;
		while(doc == null && count < 10) {
			try {
				doc = builder.parse(p_oFileToProcess);
			}
			catch (Exception e) {
				exception = e;

			}
			finally {
				count++;
			}
		}
		if(doc == null) {
			throw exception;
		}
		return doc;
	}

	/**
	 * This method write a Document into a given file
	 * @param p_oModifiedDocument The Document object to write
	 * @param p_oFileToWrite The file to write
	 */
	private void writeFile(Document p_oModifiedDocument, File p_oFileToWrite) {
		log.debug("UpgraderTo410#writeFile : " + p_oFileToWrite.getAbsolutePath());
		try {

			// Use a Transformer for output
			TransformerFactory tFactory =
					TransformerFactory.newInstance();
			Transformer transformer = tFactory.newTransformer();

			DOMSource source = new DOMSource(p_oModifiedDocument);
			StreamResult result = new StreamResult(p_oFileToWrite);
			transformer.transform(source, result); 
		} catch (TransformerConfigurationException tce) {
			// Error generated by the parser
			log.debug("* Transformer Factory error");
			log.debug("  " + tce.getMessage() );

			// Use the contained exception, if any
			Throwable x = tce;
			if (tce.getException() != null)
				x = tce.getException();
			x.printStackTrace(); 
		} catch (TransformerException te) {
			// Error generated by the parser
			log.debug ("* Transformation error");
			log.debug("  " + te.getMessage() );

			// Use the contained exception, if any
			Throwable x = te;
			if (te.getException() != null)
				x = te.getException();
			x.printStackTrace();
		}
	}



	private String readFile(File p_oFileToRead) {
		String sFileResult = null;
		try {
			FileReader oFrr = new FileReader(p_oFileToRead);
			try {
				StringBuilder oSb = new StringBuilder();
				char c = (char) oFrr.read();
				while(c!=65535) {
					oSb.append(c);
					c = (char) oFrr.read();
				}
				sFileResult = oSb.toString().trim();
			}
			catch (IOException e) {
				e.printStackTrace();
			}
			finally {
				oFrr.close();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		catch (IOException e) {
			e.printStackTrace();
		}

		sFileResult = sFileResult.replaceAll("\\n", " ");
		sFileResult = sFileResult.replaceAll(">\\s*<", "><");

		return sFileResult;
	}
}



