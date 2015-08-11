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

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.OpenOption;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.a2a.adjava.projectupgrader.AbstractProjectUpgrader;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.XProject;

public class UpgraderTo440 extends AbstractProjectUpgrader {

	@Override
	public void executeFixesForAndroid(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		Map<String, String> sEffectiveChangesMapping = new HashMap<>();
		
		deleteBeansAction(p_oDomain, sEffectiveChangesMapping);
		
		deleteActionProvider(p_oDomain, sEffectiveChangesMapping);
		
		writeChangesLogFile(p_oDomain, sEffectiveChangesMapping);
		
	}

	@Override
	public void executeFixesForIOS(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
	}

	/**
	 * Delete action provider declarations
	 * @param p_oDomain project domain
	 * @param p_oEffectiveChangesMapping map of changes
	 */
	private void deleteActionProvider(
			IDomain<IModelDictionary, IModelFactory> p_oDomain,
			Map<String, String> p_oEffectiveChangesMapping) {
		
	
		// get directory
		XProject oProject = p_oDomain.getProject("application");
	
		File oDirectory = new File(oProject.getBaseDir() + "/res/menu");
		if (oDirectory == null || ! oDirectory.exists()) {
			return;
		}
		
		File[] oListOFiles = oDirectory.listFiles(new FilenameFilter() {
		    public boolean accept(File dir, String name) {
		    	return name.toLowerCase().endsWith(".xml");
		    }
		});
		
		String pattern = "mdkapp:actionProviderClass=\"[\\w.]+\"";
		
		for (File oFile : oListOFiles) {
			try {
				List<String> oFileLines = Files.readAllLines(oFile.toPath(), Charset.forName("UTF-8"));
				
				// delete action provider class (with reg exp)
				for (String line : oFileLines) {
					line.replaceAll(pattern, "");
				}
				
				// wirte in file?
				Files.write(oFile.toPath(), oFileLines, Charset.forName("UTF-8"), StandardOpenOption.TRUNCATE_EXISTING);
				
				// log
				p_oEffectiveChangesMapping.put(oFile.getName(), "remove \"mdkapp:actionProviderClass\"");
				
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * Delete beans actions declarations
	 * @param p_oDomain
	 * @param p_oEffectiveChangesMapping map of changes
	 */
	private void deleteBeansAction(
			IDomain<IModelDictionary, IModelFactory> p_oDomain,
			Map<String, String> p_oEffectiveChangesMapping) {
		// get the beans_action file and delete line CustomConfigurationHandlerInitImpl
		// get directory
		XProject oProject = p_oDomain.getProject("application");
	
		File oBeanActionFile = new File(oProject.getBaseDir() + "/res/raw/beans_action");
		if (oBeanActionFile == null || ! oBeanActionFile.exists()) {
			return;
		}

		String pattern = "com.adeuza.movalysfwk.mobile.mf4mjcommons.configuration.CustomConfigurationsHandlerInit=com.soprasteria.movalysmdk.it.widget.mbandroid.CustomConfigurationsHandlerInitImpl";
		
		try {
			List<String> oFileLines = Files.readAllLines(oBeanActionFile.toPath(), Charset.forName("UTF-8"));
			
			List<String> outLines = new ArrayList<>();
			
			for (String oLine : oFileLines) {
				if (!oLine.equals(pattern)) {
					outLines.add(oLine);
				}
			}
			
			Files.write(oBeanActionFile.toPath(), outLines, Charset.forName("UTF-8"), StandardOpenOption.TRUNCATE_EXISTING);
			
			// log
			p_oEffectiveChangesMapping.put(oBeanActionFile.getName(), "remove \"CustomConfigurationsHandlerInit\"");
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	/**
	 * Writes a log with the processed information
	 * @param p_oDomain 
	 * @param p_oEffectiveChangesMapping dictionary of the processed data
	 * @throws IOException
	 */
	private void writeChangesLogFile(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, String> p_oEffectiveChangesMapping) throws IOException {
		File oLogFile = new File("version/UpgradeTo440.log");

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
