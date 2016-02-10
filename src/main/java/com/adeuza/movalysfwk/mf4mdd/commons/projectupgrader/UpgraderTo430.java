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
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.projectupgrader.AbstractProjectUpgrader;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAdapter;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;

/**
 * Upgrader for version 4.3.0
 */
public class UpgraderTo430 extends AbstractProjectUpgrader{

	/**
	 * logger
	 */
	private static final Logger log = LoggerFactory.getLogger(UpgraderTo430.class);
	
	private static final Map<String, String> componentsNameMap = new HashMap<String, String>();
	static {
		componentsNameMap.put("MMDoublePickerGroup","MMDoublePicker");
		componentsNameMap.put("MMDurationPickerGroup","MMDurationPicker");
		componentsNameMap.put("MMEmailEditTextGroup","MMEmailEditText");
		componentsNameMap.put("MMEmailSimpleEditTextGroup","MMEmailSimpleEditText");
		componentsNameMap.put("MMEmailSimpleViewTextGroup","MMEmailSimpleTextView");
		componentsNameMap.put("MMEmailTextViewGroup","MMEmailTextView");
		componentsNameMap.put("MMMultiAutoCompleteEditTextGroup","MMMultiAutoCompleteEditText");
		componentsNameMap.put("MMMultiTextViewWithEditDialogGroup","MMMultiAutoCompleteEditTextWithDialog");
		componentsNameMap.put("MMPhoneTextViewGroup","MMPhoneTextView");
		componentsNameMap.put("MMURLEditViewGroup","MMURLEditText");
		componentsNameMap.put("MMURLTextViewGroup","MMURLTextView");
		componentsNameMap.put("MMScanEditTextGroup","MMScanEditText");
	}
	
	@Override
	public void executeFixesForAndroid(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		Map<String, String> sEffectiveChangesMapping = new HashMap<>();
		
		renameComponents(p_oDomain, sEffectiveChangesMapping);
		
		writeChangesLogFile(p_oDomain, sEffectiveChangesMapping);
	}

	@Override
	public void executeFixesForIOS(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
	}
	
	/**
	 * Renames the components to their new names in 4.3.0 
	 * @param p_sEffectiveChangesMapping
	 */
	private void renameComponents(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		renameComponentsInScreens(p_oDomain, p_sEffectiveChangesMapping);
		renameComponentsInPanels(p_oDomain, p_sEffectiveChangesMapping);
		renameComponentsInAdapters(p_oDomain, p_sEffectiveChangesMapping);
		renameComponentsInManifest(p_oDomain, p_sEffectiveChangesMapping);
		renameComponentsInLayouts(p_oDomain, p_sEffectiveChangesMapping);
		renameComponentsInViewModelCreator(p_oDomain, p_sEffectiveChangesMapping);
	}
	
	/**
	 * Process screens
	 * @param p_oDomain domain to use
	 * @param p_sEffectiveChangesMapping changes map
	 */
	private void renameComponentsInScreens(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		XProject oProject = p_oDomain.getProject("application");
		
		if (oProject.getDomain().getDictionnary().getAllScreens().size() > 0) {
			MScreen oScreen = (MScreen) oProject.getDomain().getDictionnary().getAllScreens().toArray()[0];
	
			File oDirectory = this.getDirectoryForModule(oProject, oScreen.getPackage().getFullName().replace('.', '/'), false);
			
			this.renameComponentsFromFilesInDirectory(oDirectory, ".java", p_sEffectiveChangesMapping);
			
			oDirectory = this.getDirectoryForModule(oProject, oScreen.getPackage().getFullName().replace('.', '/'), true);
			
			this.renameComponentsFromFilesInDirectory(oDirectory, ".xml", p_sEffectiveChangesMapping);
		}
	}

	/**
	 * process panels
	 * @param p_oDomain domain to use
	 * @param p_sEffectiveChangesMapping changes map
	 */
	private void renameComponentsInPanels(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		XProject oProject = p_oDomain.getProject("application");
		
		if (oProject.getDomain().getDictionnary().getAllScreens().size() > 0) {
			MPage oPage = ((MScreen) (oProject.getDomain().getDictionnary().getAllScreens().toArray()[0])).getPages().get(0);
	
			File oDirectory = this.getDirectoryForModule(oProject, oPage.getPackage().getFullName().replace('.', '/'), false);
			
			this.renameComponentsFromFilesInDirectory(oDirectory, ".java", p_sEffectiveChangesMapping);
	
			oDirectory = this.getDirectoryForModule(oProject, oPage.getPackage().getFullName().replace('.', '/'), true);
			
			this.renameComponentsFromFilesInDirectory(oDirectory, ".xml", p_sEffectiveChangesMapping);
		}
	}

	/**
	 * process adapters
	 * @param p_oDomain domain to use
	 * @param p_sEffectiveChangesMapping changes map
	 */
	private void renameComponentsInAdapters(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		XProject oProject = p_oDomain.getProject("application");
		
		if (oProject.getDomain().getDictionnary().getAllAdapters().size() > 0) {
			MAdapter oAdapter = (MAdapter) oProject.getDomain().getDictionnary().getAllAdapters().toArray()[0];
			
			File oDirectory = this.getDirectoryForModule(oProject, oAdapter.getPackage().getFullName().replace('.', '/'), false);
			
			this.renameComponentsFromFilesInDirectory(oDirectory, ".java", p_sEffectiveChangesMapping);
	
			oDirectory = this.getDirectoryForModule(oProject, oAdapter.getPackage().getFullName().replace('.', '/'), true);
			
			this.renameComponentsFromFilesInDirectory(oDirectory, ".xml", p_sEffectiveChangesMapping);
		}
	}

	/**
	 * process android manifest
	 * @param p_oDomain domain to use
	 * @param p_sEffectiveChangesMapping changes map
	 */
	private void renameComponentsInManifest(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		File oDirectory = this.getDirectoryForProject(p_oDomain, "application", true);
		
		this.renameComponentsFromFilesInDirectory(oDirectory, ".xml", p_sEffectiveChangesMapping);
	}

	/**
	 * process layout
	 * @param p_oDomain domain to use
	 * @param p_sEffectiveChangesMapping changes map
	 */
	private void renameComponentsInLayouts(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		XProject oProject = p_oDomain.getProject("application");
		
		if (oProject.getDomain().getDictionnary().getAllLayouts().size() > 0) {
			File oDirectory = new File(oProject.getBaseDir() + "/" + oProject.getLayoutDir());
			
			this.renameComponentsFromFilesInDirectory(oDirectory, ".xml", p_sEffectiveChangesMapping);
	
			oDirectory = new File(oProject.getBaseDir() + "/" + oProject.getLayoutDir() + "/debug");
			
			this.renameComponentsFromFilesInDirectory(oDirectory, ".xml", p_sEffectiveChangesMapping);
		}
	}

	/**
	 * process view model creator
	 * @param p_oDomain domain to use
	 * @param p_sEffectiveChangesMapping changes map
	 */
	private void renameComponentsInViewModelCreator(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		XProject oProject = p_oDomain.getProject("viewmodel");
		
		File oDirectory =this.getDirectoryForModule(oProject, oProject.getDomain().getDictionnary().getViewModelCreator().getPackage().getFullName().replace('.', '/'), true);
		
		this.renameComponentsFromFilesInDirectory(oDirectory, ".xml", p_sEffectiveChangesMapping);
	}

	/**
	 * Returns the directory of a given project
	 * @param p_oDomain domain to use
	 * @param p_sProjectName name of the project
	 * @param p_bDebugDir true if we should find the debug dir
	 * @return
	 */
	private File getDirectoryForProject(IDomain<IModelDictionary, IModelFactory> p_oDomain, String p_sProjectName, boolean p_bDebugDir) {
		String sProjectDir = StringUtils.join( 
				p_oDomain.getProject(p_sProjectName).getBaseDir() + "/" + 
				p_oDomain.getProject(p_sProjectName).getSourceDir(), "/", 
				p_oDomain.getProject(p_sProjectName).getDomain().getRootPackage().replace('.', '/'));
		
		if (p_bDebugDir) {
			sProjectDir = StringUtils.join(sProjectDir, "/debug");
		}
		
		log.debug("UpgraderTo430#getDirectoryForModule " + p_sProjectName + " / debug " + p_bDebugDir + " : " + sProjectDir);
		
		return new File(sProjectDir);
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
		
		log.debug("UpgraderTo430#getDirectoryForModule " + p_sModulePath + " / debug " + p_bDebugDir + " : " + sProjectDir);
		
		return new File(sProjectDir);
	}
	
	/**
	 * Replaces the old component names to the new ones in the files with the given extension found in the given directory
	 * @param p_oDirectory the directory to scan
	 * @param p_sFileExtension the file extension to filter
	 * @param p_sEffectiveChangesMapping the changes processed
	 */
	private void renameComponentsFromFilesInDirectory(File p_oDirectory, final String p_sFileExtension, Map<String, String> p_sEffectiveChangesMapping) {
		if (p_oDirectory == null || ! p_oDirectory.exists()) {
			return;
		}
		
		File[] oListOFiles = p_oDirectory.listFiles(new FilenameFilter() {
		    public boolean accept(File dir, String name) {
		    	return name.toLowerCase().endsWith(p_sFileExtension);
		    }
		});
		
		for (File oFile : oListOFiles) {
			log.debug("UpgraderTo430#Processing file " + oFile.getName());
			try {
		        BufferedReader oReader = new BufferedReader(new FileReader(oFile));
		        String sLine = "", sNewContent = "";
		        boolean bFound = false;
		        while ((sLine = oReader.readLine()) != null) {
		        	for (Entry<String, String> oComponentName : componentsNameMap.entrySet()) {
			            if (sLine.contains(oComponentName.getKey())) {
			            	log.debug("UpgraderTo430#Processing file ; found old component " + oComponentName.getKey());
			            	p_sEffectiveChangesMapping.put(oFile.getName(), oComponentName.getKey() + " -> " + oComponentName.getValue());
			                sLine.replaceAll(oComponentName.getKey(), oComponentName.getValue());
			                bFound = true;
			            }
		        	}
		        	sNewContent += sLine + "\n";
		        }
		        oReader.close();

		        if (bFound) {
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
		File oLogFile = new File("version/UpgradeTo430.log");

		StringBuilder oContentBuilder = new StringBuilder();
		oContentBuilder.append(
			"La liste suivante représente les modifications "
			+ "suite à la migration du projet en 4.3.0.\n ");
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
