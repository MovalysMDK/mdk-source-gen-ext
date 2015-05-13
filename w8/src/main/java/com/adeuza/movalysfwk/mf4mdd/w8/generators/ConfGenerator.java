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
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import org.codehaus.plexus.util.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.w8.xmodele.MW8VisualField;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;

/**
 * <p>
 * Generate configuration fields xml of view models
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

public class ConfGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {
	
	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(LabelGenerator.class);
	
	/**
	 * Generated file
	 */
	private static final String GENERATED_FILE_FIELD = "configDictionaryFieldsDefault";
	
	/**
	 * Xsl file
	 */
	private static final String XSL_FILE_FIELD = "fields-visual-property.xsl";
	
	Map<String,Map<String,String>> mapfields = new HashMap<String,Map<String,String>>();

	/**
	 * {@inheritDoc}
	 */
	public void genere(
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> LabelGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		for( Locale oLocale : this.getLocales()) {	
			Element xFields = DocumentHelper.createElement("fields");
			Element xResources = DocumentHelper.createElement("labels");
			xResources.addElement("base-package").setText(p_oMProject.getDomain().getRootPackage());
			this.genLabelsForLayout(p_oMProject);
			
			this.buildDocFields(xFields, oLocale);
			
			Document xInterfacesDocumentFields = DocumentHelper.createDocument(xFields);
			
			String oTargetFileFields = this.getOutputFileFields(p_oMProject, oLocale);
				
			this.doIncrementalTransform(XSL_FILE_FIELD, oTargetFileFields, xInterfacesDocumentFields, p_oMProject, p_oGeneratorContext);
		}

		log.debug("< LabelGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Generate conf for layout : fields end buttons
	 * @param p_mapLabels labels 
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void genLabelsForLayout(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) throws Exception {
		if (!p_oMProject.getDomain().getDictionnary().getAllLayouts().isEmpty()) {

			for (MLayout oLayout : p_oMProject.getDomain().getDictionnary().getAllLayouts()) {
				for (MVisualField oField : oLayout.getFields()) {
					MViewModelImpl oMViewModel = null;
					for(MViewModelImpl oMViewModelImpl : p_oMProject.getDomain().getDictionnary().getAllViewModels()){
						if(oMViewModelImpl.getName() == oField.getViewModelName()){
							oMViewModel = oMViewModelImpl;
							break;
						}
					}
					String key = oField.getViewModelName();
					if(oMViewModel != null){
						if(oMViewModel.getType().name().equalsIgnoreCase(ViewModelType.LIST_1__ONE_SELECTED.toString())){		
							key += "Item";
						} else if(oMViewModel.getType().name().equalsIgnoreCase(ViewModelType.FIXED_LIST.toString())){
							key += "ItemCell";
						}
					}
					key += "." + StringUtils.capitalise(oField.getViewModelProperty());
					Map<String,String> fieldValues = new HashMap<String,String>();
					fieldValues.put("IsCreateLabel", String.valueOf(oField.isCreateLabel()));
					fieldValues.put("IsEnabled", String.valueOf(!oField.isReadOnly()));
					fieldValues.put("IsMandatory", String.valueOf(oField.isMandatory()));
					mapfields.put(key, fieldValues);
				}
			}
		}
	}
	
	/**
	 * Build xml from map of visual properties of fields
	 * @param p_mapLabels map of visual properties of fields
	 * @param p_xVisualProperties xml output
	 * @param p_oLocale locale
	 */
	private void buildDocFields(Element p_xVisualProperties, Locale p_oLocale) {
		for( Entry<String,Map<String,String>> oEntry : mapfields.entrySet()) {
			Map<String,String> fieldValues = oEntry.getValue();
			Element xElField = p_xVisualProperties.addElement("field");
			xElField.addAttribute("name", oEntry.getKey());
			Element xElVisualProperties = xElField.addElement("visual-properties");
			for( Entry<String,String> oEntry2 : fieldValues.entrySet()) {
				Element xElVisualProperty = xElVisualProperties.addElement("visual-property");
				xElVisualProperty.addAttribute("name", oEntry2.getKey());
				xElVisualProperty.setText(oEntry2.getValue());
			}
		}
	}
	
	/**
	 * Return output file for xsl generation
	 * @param p_oProject project
	 * @return output file
	 */
	protected String getOutputFileFields( XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oProject, Locale p_oLocale ) {
		return FileTypeUtils.computeFilenameForXmlClass(p_oProject.getSourceDir() + "/Common",
				GENERATED_FILE_FIELD);
	}
	
	/**
	 * Return locales to generate labels for
	 * @return locales
	 */
	protected Locale[] getLocales() {
		return new Locale[] { Locale.FRENCH };
	}
}