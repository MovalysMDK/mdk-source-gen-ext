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
package com.adeuza.movalysfwk.mf4mdd.w8.generators;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.LanguageConfiguration;
import com.a2a.adjava.uml2xmodele.extractors.viewmodel.VMNamingHelper;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MDaoImpl;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelCreator;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;

/**
 * <p>
 * Generate properties of view models
 * </p>
 * 
 * <p>
 * Copyright (c) 2011
 * <p>
 * Company: Adeuza
 * 
 * @author smaitre
 * 
 */

public class ClassLoaderPropertyGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {
	
	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(ClassLoaderPropertyGenerator.class);
	
	/**
	 * Generated file
	 */
	private static final String GENERATED_FILE_FIELD = "ClassLoader.properties";
	
	/**
	 * Xsl file
	 */
	private static final String XSL_FILE_FIELD = "class-loader-property.xsl";
	
	Map<String,String> mapfields = new HashMap<String,String>();

	/**
	 * {@inheritDoc}
	 */
	public void genere(
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> ClassLoaderPropertyGenerator.genere");
		Chrono oChrono = new Chrono(true);
				
		Element xProperties = DocumentHelper.createElement("properties");
		this.genPropertiesForLayout(p_oMProject);
		
		this.buildDocProperties(xProperties);
		
		String oTargetFileFields = this.getOutputFileProperties(p_oMProject);
		
		Document xInterfacesDocumentFields = DocumentHelper.createDocument(xProperties);

		this.doIncrementalTransform(XSL_FILE_FIELD, oTargetFileFields, xInterfacesDocumentFields, p_oMProject, p_oGeneratorContext);

		log.debug("< ClassLoaderPropertyGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Generate labels for layout : fields end buttons
	 * @param p_mapLabels labels 
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void genPropertiesForLayout(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) throws Exception {
		if (!p_oMProject.getDomain().getDictionnary().getAllLayouts().isEmpty()) {

			LanguageConfiguration langConf = p_oMProject.getDomain().getLanguageConf();
			
			for (MEntityImpl oEntity : p_oMProject.getDomain().getDictionnary().getAllEntities()) {
				mapfields.put(oEntity.getMasterInterface().getName(), "Model," + oEntity.getFullName() + "=" + oEntity.getMasterInterface().getName() + "Factory");
				mapfields.put(oEntity.getMasterInterface().getName() + "Factory", "Model," + oEntity.getFullName()  + "Factory");
			}
			
			for (MDaoImpl oDao : p_oMProject.getDomain().getDictionnary().getAllDaos()) {
				mapfields.put(oDao.getMasterInterface().getName(), "Dao," + oDao.getFullName());
			}
			for (MDataLoader oMDataLoader : p_oMProject.getDomain().getDictionnary().getAllDataLoaders()) {
				mapfields.put(oMDataLoader.getMasterInterface().getName(), "DataLoader," + oMDataLoader.getFullName());
			}
			for (MViewModelImpl oVmImpl : p_oMProject.getDomain().getDictionnary().getAllViewModels()) {
				mapfields.put(oVmImpl.getMasterInterface().getName(), "ViewModel," + oVmImpl.getFullName());
			}
			MViewModelCreator vmCreator = p_oMProject.getDomain().getDictionnary().getViewModelCreator();
			mapfields.put(p_oMProject.getDomain().getLanguageConf().getInterfaceNamingPrefix()+vmCreator.getName(), "ViewModel," + vmCreator.getFullName());
			for (MAction oAction : p_oMProject.getDomain().getDictionnary().getAllActions()) {
				mapfields.put(oAction.getMasterInterface().getName(), "View," + oAction.getFullName());
			}
			for (MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
				if (oScreen.getPages() != null) {
					for (MPage oPage : oScreen.getPages()) {
						mapfields.put(VMNamingHelper.getInstance().computeSectionInterfaceName(oPage.getName(),false,langConf), 
								"View," + oPage.getPackage().getFullName() + "." + 
										VMNamingHelper.getInstance().computeSectionImplementationName(oPage.getName(),false,langConf)
										);
					}
				}
				mapfields.put(oScreen.getName()+"Controller",
						"Application," + oScreen.getPackage().getFullName() + "." +
							oScreen.getName()+"Controller"
							);
			}
		}
	}
		
	/**
	 * Build xml from map of labels
	 * @param p_mapLabels map of labels
	 * @param p_xLabels xml output
	 * @param p_oLocale locale
	 */
	private void buildDocProperties(Element p_xLabels) {
		for( Entry<String,String> oEntry : mapfields.entrySet()) {
			Element xEl = p_xLabels.addElement("property");
			xEl.addAttribute("name", oEntry.getKey());
			xEl.setText(oEntry.getValue());
		}
	}
	
	/**
	 * Return output file for xsl generation
	 * @param p_oProject project
	 * @return output file
	 */
	protected String getOutputFileProperties( XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oProject) {
		log.debug(p_oProject.getSourceDir() + "/Common/" + GENERATED_FILE_FIELD);
		return p_oProject.getSourceDir() + "/Common/" + GENERATED_FILE_FIELD;
	}
}