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
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.projectupgrader.AbstractProjectUpgrader;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAdapter;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;

/**
 * Upgrader for version 4.0.9
 */
public class UpgraderTo409 extends AbstractProjectUpgrader{

	/**
	 * logger
	 */
	private static final Logger log = LoggerFactory.getLogger(UpgraderTo409.class);
	
	/**
	 * domain
	 */
	private IDomain<IModelDictionary, IModelFactory> oDomain;
	
	/**
	 * existing files
	 */
	private Map<String, Map<String, File>> listOfAdapters;

	@Override
	public void executeFixesForAndroid(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		Map<String, String> effectiveChangesMapping = new HashMap<>();
		this.oDomain = p_oDomain;
		
		this.listOfAdapters = processAdapterFiles();
		
		for (MScreen oScreen : p_oDomain.getDictionnary().getAllScreens()) {
			for (MPage oPage : oScreen.getPages()) {
				for (MAdapter oAdapter : oPage.getExternalAdapters().values()) {
					if (oAdapter.getViewModel().getType().equals(ViewModelType.LIST_1__ONE_SELECTED)) {
						processAdapter(oPage, oAdapter, effectiveChangesMapping);
					}
				}
			}
		}
		
		System.out.println("MAPPING : " + effectiveChangesMapping);
		writeChangesLogFile(effectiveChangesMapping);
	}


	@Override
	public void executeFixesForIOS(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
	}

	/**
	 * processes the given adapter
	 * @param p_oPage page hosting the adapter
	 * @param p_oAdapter adapter to process
	 * @param p_oAdapterNamesMapping result dictionary
	 */
	private void processAdapter(MPage p_oPage, MAdapter p_oAdapter, Map<String, String> p_oAdapterNamesMapping) {
		String sOldName = computeOldAdapterName(p_oAdapter.getViewModel());
		String sNewName = computeNewAdapterName(p_oPage, p_oAdapter.getViewModel());
		
		Map<String, File> oFile = this.listOfAdapters.get(sOldName);
		
		String sAdapterVmInterface = p_oAdapter.getViewModel().getMasterInterface().getName();
		
		if (oFile != null && oFile.containsKey(sAdapterVmInterface)) {
			p_oAdapterNamesMapping.put(sOldName, sNewName);
			oFile.get(sAdapterVmInterface).renameTo(new File (getAdaptersFolder() + "/" + sNewName + ".java"));
		}
	}
	
	/**
	 * Computes adapter name 4.0.8 and prior style
	 * @param p_oVm viewmodel of the spinner
	 * @return 4.0.8 style adapter name
	 */
	private String computeOldAdapterName(MViewModelImpl p_oVm) {
		return this.oDomain.getLanguageConf().getAdapterImplementationNamingPrefix()
				+ p_oVm.getUmlName()
				+ this.oDomain.getLanguageConf().getAdapterImplementationNamingSuffix();
	}
	
	/**
	 * Computes adapter name 4.0.9 style
	 * @param p_oPage
	 * @param p_oExtVm
	 * @return 4.0.9 style adapter name
	 */
	private String computeNewAdapterName(MPage p_oPage, MViewModelImpl p_oExtVm) {
		return this.oDomain.getLanguageConf().getAdapterImplementationNamingPrefix()
				+ p_oPage.getUmlName() + p_oExtVm.getUmlName() 
				+ this.oDomain.getLanguageConf().getAdapterImplementationNamingSuffix();
	}

	/**
	 * Looks for the view model of an adapter in the java file
	 * @param p_oFile java file of the adapter
	 * @return name of the view model of the adapter
	 */
	private String findViewModelInFile(File p_oFile) {
		String r_oVmName = null;
		
		try {
			String sFileContent = getFileContent(p_oFile);
			Pattern pattern = Pattern.compile("(ListViewModel[\\<][\\w ]+,{1}[\\w ]+[\\>])");
			Matcher matcher = pattern.matcher(sFileContent);
			if (matcher.find()) {
				String sMatcher = matcher.group(0);
				r_oVmName = sMatcher.substring(sMatcher.indexOf(",") + 1, sMatcher.indexOf(">")).trim();
			}
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
		return r_oVmName;
	}
	
	/**
	 * Returns a string containing the whole file given as a parameter
	 * @param p_oFile file to read 
	 * @return content of the file
	 * @throws IOException
	 */
	private String getFileContent(File p_oFile) throws IOException {
		BufferedReader oBufferedReader = new BufferedReader(new InputStreamReader(new FileInputStream(p_oFile), this.oDomain.getFileEncoding()));

		StringBuilder oFullLayoutContentBuilder = new StringBuilder();
		String line;
		while ((line = oBufferedReader.readLine()) != null) {
			oFullLayoutContentBuilder.append(line);
		}
		oBufferedReader.close();
		oBufferedReader = null;


		String sFinalLayoutContent = oFullLayoutContentBuilder.toString();
		
		return sFinalLayoutContent;
	}

	/**
	 * Reads existing adapter java files and feeds a dictionary with their names and related view models
	 * @return processed dictionary
	 */
	private Map<String, Map<String, File>> processAdapterFiles() {
		String sPath = getAdaptersFolder();
		File oAdapterFolder = new File(sPath);
		
		System.out.println("SPATH : " + sPath);
		
		File[] oListOfAdapters = oAdapterFolder.listFiles(new FilenameFilter() {
		    public boolean accept(File dir, String name) {
		        return name.toLowerCase().endsWith(".java");
		    }
		});
		
		Map<String, Map<String, File>> r_listOfAdapters = new HashMap<String, Map<String, File>>();
		
		for (File oFile : oListOfAdapters) {
			Map<String, File> oVmFile = new HashMap<String, File>();
			
			String sVmName = findViewModelInFile(oFile);
			if (sVmName != null) {
				oVmFile.put(sVmName, oFile);
				
				r_listOfAdapters.put(oFile.getName().split("\\.")[0], oVmFile);
			} else {
				log.error("View model not found in adapter file {}", oFile.getName());
			}
		}
		
		return r_listOfAdapters;
	}

	/**
	 * Returns the folder of the project containing the adapters
	 * @return folder
	 */
	private String getAdaptersFolder() {
		String sPath = oDomain.getProject("application").getBaseDir() + "/" + oDomain.getProject("application").getSourceDir() + "/" +
				oDomain.getDictionnary().getAllAdapters().iterator().next().getPackage().getFullName().replace(".", "/");
		return sPath;
	}

	/**
	 * Writes a log with the processed information
	 * @param p_oEffectiveChangesMapping dictionary of the processed data
	 * @throws IOException
	 */
	private void writeChangesLogFile(Map<String, String> p_oEffectiveChangesMapping) throws IOException {
		File oLogFile = new File("version/UpgradeTo409.log");

		StringBuilder oContentBuilder = new StringBuilder();
		oContentBuilder.append(
			"La liste suivante représente pour les fichiers d'adapter renommés "
			+ "suite à la migration du projet en 4.0.9. (Ancien nom / Nouvel nom)\n ");
		oContentBuilder.append(printChangesMap(p_oEffectiveChangesMapping));
		BufferedWriter oBufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(oLogFile), this.oDomain.getFileEncoding()));
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



