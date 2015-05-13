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

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.projectupgrader.AbstractProjectUpgrader;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XProject;

/**
 * Upgrader for version 4.4.1
 * Fixes missing [X] on class signatures
 */
public class UpgraderTo441 extends AbstractProjectUpgrader{

	/**
	 * logger
	 */
	private static final Logger log = LoggerFactory.getLogger(UpgraderTo441.class);
	
	/** stores already processed paths */
	private List<String> processedPaths;
	
	@Override
	public void executeFixesForAndroid(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		Map<String, String> sEffectiveChangesMapping = new HashMap<>();
		
		addXToViewModels(p_oDomain, sEffectiveChangesMapping);
		
		addXToActions(p_oDomain, sEffectiveChangesMapping);
		
		writeChangesLogFile(p_oDomain, sEffectiveChangesMapping);
	}

	@Override
	public void executeFixesForIOS(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
	}
	
	/**
	 * process view model classes
	 * @param p_oDomain domain to use
	 * @param p_sEffectiveChangesMapping changes map
	 */
	private void addXToViewModels(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		XProject oProject = p_oDomain.getProject("viewmodel");
		
		processedPaths = new ArrayList<String>();
		
		for (MViewModelImpl oVM : oProject.getDomain().getDictionnary().getAllViewModels()) {
			String sViewModelPath = oVM.getPackage().getFullName().replace('.', '/');
			
			if (!processedPaths.contains(sViewModelPath)) {
				processedPaths.add(sViewModelPath);
				File oDirectory = this.getDirectoryForModule(oProject, sViewModelPath, false);
				this.addXToClassTagInDirectory(oDirectory, "AbstractItemViewModel<.*>", p_sEffectiveChangesMapping);
			}
		}
	}

	/**
	 * processes actions classes
	 * @param p_oDomain
	 * @param p_sEffectiveChangesMapping
	 */
	private void addXToActions(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		XProject oProject = p_oDomain.getProject("application");
		
		processedPaths = new ArrayList<String>();
		
		for (MAction oAction : oProject.getDomain().getDictionnary().getAllActions()) {
			String sActionPath = oAction.getPackage().getFullName().replace('.', '/');
			
			if (!processedPaths.contains(sActionPath)) {
				processedPaths.add(sActionPath);
				File oDirectory = this.getDirectoryForModule(oProject, sActionPath, false);
				this.addXToClassTagInDirectory(oDirectory, "AbstractSaveDetailActionImpl<.*>", p_sEffectiveChangesMapping);
				this.addXToClassTagInDirectory(oDirectory, "AbstractPersistentSaveDetailActionImpl<.*>", p_sEffectiveChangesMapping);
			}
		}
	}

	/**
	 * Returns the directory of a given module
	 * @param p_oDomain
	 * @param p_sProjectName
	 * @param p_bDebugDir
	 * @return
	 */
	private File getDirectoryForModule(XProject p_oProject, String p_sModulePath, boolean p_bDebugDir) {
		String sProjectDir = StringUtils.join( 
				p_oProject.getBaseDir() + "/" + 
				p_oProject.getSourceDir(), "/");
		
		sProjectDir = StringUtils.join(sProjectDir, p_sModulePath);
		
		if (p_bDebugDir) {
			sProjectDir = StringUtils.join(sProjectDir, "/debug");
		}
		
		log.debug("UpgraderTo441#getDirectoryForModule " + p_sModulePath + " / debug " + p_bDebugDir + " : " + sProjectDir);
		
		return new File(sProjectDir);
	}
	
	/**
	 * Replaces the old component names to the new ones in the files with the given extension found in the given directory
	 * @param p_oDirectory the directory to scan
	 * @param p_sFileExtension the file extension to filter
	 * @param p_sEffectiveChangesMapping the changes processed
	 */
	private void addXToClassTagInDirectory(File p_oDirectory, String p_sBasicExtends, Map<String, String> p_sEffectiveChangesMapping) {
		if (p_oDirectory == null || ! p_oDirectory.exists()) {
			return;
		}
		
		File[] oListOFiles = p_oDirectory.listFiles(new FilenameFilter() {
		    public boolean accept(File dir, String name) {
		    	return name.toLowerCase().endsWith(".java");
		    }
		});
		
		for (File oFile : oListOFiles) {
			log.debug("UpgraderTo441#Processing file " + oFile.getName());
			try {
		        BufferedReader oReader = new BufferedReader(new FileReader(oFile));
		        String sLine = "", sNewContent = "";
		        List<String> newClassTag = null;
		        boolean bInClassTag = false;
		        boolean bModifyBalise = false;
		        while ((sLine = oReader.readLine()) != null) {
		        	if (sLine.contains("@non-generated-start") && sLine.contains("class-signature-extends") && !sLine.contains("[X]")) {
	        			log.debug("UpgraderTo441#Processing file ; found tag class-signature-extends");
	        			bInClassTag = true;
	        			newClassTag = new ArrayList<String>();
	        			newClassTag.add(sLine);
	        		} else if (bInClassTag && sLine.contains("@non-generated-end")) {
	        			newClassTag.add(sLine);
	        			String sWholeTag = "";
	        			for (String sClassLine : newClassTag) {
	        				sWholeTag += sClassLine + "\n";
	        			}
	        			
	        			Pattern oPattern = Pattern.compile("\\s*//@non-generated-start\\s*\\[class-signature-extends\\]\\s*extends\\s*"
	        					+ p_sBasicExtends
	        					+ "\\s*//@non-generated-end");
	        			
	        			Matcher oMatcher = oPattern.matcher(sWholeTag);
	        			
	        			if (oMatcher.find()) {
	        				for (String sClassLine : newClassTag) {
	        					if (sClassLine.contains("class-signature-extends")) {
	        						bModifyBalise = true;
		        					sClassLine = sClassLine.concat("[X]");
		        					p_sEffectiveChangesMapping.put(oFile.getName(), "added [X] to class-signature-extends");
		        				}
	        					sNewContent += sClassLine + "\n";
		        			}
	        			}
	        			
	        			bInClassTag = false;
	        		} else {
			        	if (!bInClassTag) {
			        		sNewContent += sLine + "\n";
			        	} else {
		        			newClassTag.add(sLine);
			        	}
	        		}
		        }
		        oReader.close();

		        if (bModifyBalise) {
			        FileWriter oWriter = new FileWriter(oFile);
			        oWriter.write(sNewContent);
			        oWriter.close();
		        }
		    } catch (IOException ioe) {
		        ioe.printStackTrace();
		    }
		}
	}

	/**
	 * Writes a log with the processed information
	 * @param p_oDomain 
	 * @param p_oEffectiveChangesMapping dictionary of the processed data
	 * @throws IOException
	 */
	private void writeChangesLogFile(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_oEffectiveChangesMapping) throws IOException {
		File oLogFile = new File("version/UpgradeTo441.log");

		StringBuilder oContentBuilder = new StringBuilder();
		oContentBuilder.append(
			"La liste suivante représente les modifications "
			+ "suite à la migration du projet en 4.4.1.\n ");
		oContentBuilder.append(printChangesMap(p_oEffectiveChangesMapping));
		BufferedWriter oBufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(oLogFile), p_oDomain.getFileEncoding()));
		oBufferedWriter.write(oContentBuilder.toString());
		oBufferedWriter.close();
	}

	/**
	 * Returns the processed data
	 * @param p_oEffectiveChangesMapping processed data
	 * @return string
	 */
	private String printChangesMap(Map<String, String> p_oEffectiveChangesMapping) {

		StringBuilder oBuilder = new StringBuilder();
		oBuilder.append("*********************************************\n");
		for(String sLayoutKeyString : p_oEffectiveChangesMapping.keySet()) {
			oBuilder.append(sLayoutKeyString).append('=').append(p_oEffectiveChangesMapping.get(sLayoutKeyString)).append('\n');
		}
		oBuilder.append("*********************************************\n");
		oBuilder.append('\n');
		return oBuilder.toString();

	}

}
