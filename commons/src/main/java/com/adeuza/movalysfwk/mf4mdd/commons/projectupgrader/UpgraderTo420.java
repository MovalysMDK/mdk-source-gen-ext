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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.projectupgrader.AbstractProjectUpgrader;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MJoinEntityImpl;

/**
 * Upgrader for version 4.2.0
 */
public class UpgraderTo420 extends AbstractProjectUpgrader{

	/**
	 * logger
	 */
	private static final Logger log = LoggerFactory.getLogger(UpgraderTo420.class);

	/**
	 * Suffixe représentant les cascades associées à une entité.
	 */
	private static final String CASCADE_SUFFIX = "Cascade";
	
	@Override
	public void executeFixesForAndroid(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		Map<String, String> sEffectiveChangesMapping = new HashMap<>();
		
		// Mantis #21226
		deleteItemEnumClass(p_oDomain, sEffectiveChangesMapping);
		
		// Mantis #21225
		deleteUnusedCascades(p_oDomain, sEffectiveChangesMapping);
		
		writeChangesLogFile(p_oDomain, sEffectiveChangesMapping);
	}

	@Override
	public void executeFixesForIOS(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
	}

	/**
	 * deletes the ItemEnum.java file as it is deprecated in 4.2.0
	 * @param p_oDomain 
	 * @param p_sEffectiveChangesMapping 
	 */
	private void deleteItemEnumClass(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		String sItemEnumFile = StringUtils.join( 
				p_oDomain.getProject("application").getBaseDir() + "/" + 
				p_oDomain.getProject("application").getSourceDir(), "/", 
				p_oDomain.getProject("application").getDomain().getRootPackage().replace('.', '/'), "/ItemEnum.java" );
		
		log.debug("UpgraderTo420#deleteItemEnumClass : sItemEnumFile value is : "  + sItemEnumFile);
		
		File oItemEnumFile = new File(sItemEnumFile);
		
		deleteFile(p_sEffectiveChangesMapping, oItemEnumFile);
	}

	/**
	 * @param p_sEffectiveChangesMapping
	 * @param p_oItemEnumFile
	 */
	private void deleteFile(Map<String, String> p_sEffectiveChangesMapping, File p_oItemEnumFile) {
		log.debug("UpgraderTo420#deleteFile : working on file "  + p_oItemEnumFile.getAbsolutePath());
		
		try {
			if (!p_oItemEnumFile.exists()) {
				log.error("UpgraderTo420#deleteItemEnumClass : file not found");
			} else if (!p_oItemEnumFile.canWrite()) {
				log.error("UpgraderTo420#deleteItemEnumClass : cannot write file");
			} else if (p_oItemEnumFile.delete()) {
				p_sEffectiveChangesMapping.put(p_oItemEnumFile.getName(), "Fichier supprimé");
			}
		} catch (Exception e) {
			log.error("UpgraderTo420#deleteFile : an error occured " + e.getMessage());
		}
	}

	private void deleteUnusedCascades(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_sEffectiveChangesMapping) {
		Map<String, File> cascadesFilesList = processCascadeFiles(p_oDomain);
		Map<String, Integer> classAssociationsList = new HashMap<String, Integer>();
		List<File> cascadeFilesToDelete = new ArrayList<File>();
		
		IModelDictionary oDictionnary = p_oDomain.getDictionnary();
		
		for (MEntityImpl oClass : oDictionnary.getAllEntities()) {
			classAssociationsList.put(oClass.getMasterInterface().getName(), oClass.getAssociations().size());
		}
		
		for (MJoinEntityImpl oJoinClass : oDictionnary.getAllJoinClasses()) {
			classAssociationsList.put(oJoinClass.getMasterInterface().getName(), oJoinClass .getAssociations().size());
		}
		
		for (Map.Entry<String, File> entry : cascadesFilesList.entrySet()) {
			if (classAssociationsList.containsKey(entry.getKey()) && classAssociationsList.get(entry.getKey()) == 0) {
				cascadeFilesToDelete.add(entry.getValue());
			}
		}
		
		for (File oFile : cascadeFilesToDelete) {
			deleteFile(p_sEffectiveChangesMapping, oFile);
		}
	}
	
	/**
	 * Reads existing cascade java files and feeds a dictionary with their names and related entity
	 * @return processed dictionary
	 */
	private Map<String, File> processCascadeFiles(IDomain<IModelDictionary, IModelFactory> p_oDomain) {
		String sPath = getModelsFolder(p_oDomain);
		File oAdapterFolder = new File(sPath);
		
		File[] oListOfCascades = oAdapterFolder.listFiles(new FilenameFilter() {
		    public boolean accept(File dir, String name) {
		    	return name.toLowerCase().endsWith(".java") && name.contains(CASCADE_SUFFIX);
		    }
		});
		
		Map<String, File> r_listOfCascades = new HashMap<String, File>();
		
		for (File oFile : oListOfCascades) {
			String sEntityName = oFile.getName().substring(0, oFile.getName().indexOf(CASCADE_SUFFIX));
			if (sEntityName != null) {
				r_listOfCascades.put(sEntityName, oFile);
			} else {
				log.error("View model not found in adapter file {}", oFile.getName());
			}
		}
		
		return r_listOfCascades;
	}

	/**
	 * Returns the folder of the project containing the adapters
	 * @return folder
	 */
	private String getModelsFolder(IDomain<IModelDictionary, IModelFactory> p_oDomain) {
		String sPath = p_oDomain.getProject("model").getBaseDir() + "/" + p_oDomain.getProject("model").getSourceDir() + "/" +
				p_oDomain.getDictionnary().getAllEntities().iterator().next().getPackage().getFullName().replace(".", "/");
		return sPath;
	}
	
	/**
	 * Writes a log with the processed information
	 * @param p_oDomain 
	 * @param p_oEffectiveChangesMapping dictionary of the processed data
	 * @throws IOException
	 */
	private void writeChangesLogFile(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_oEffectiveChangesMapping) throws IOException {
		File oLogFile = new File("version/UpgradeTo420.log");

		StringBuilder oContentBuilder = new StringBuilder();
		oContentBuilder.append(
			"La liste suivante représente les modifications "
			+ "suite à la migration du projet en 4.2.0.\n ");
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
