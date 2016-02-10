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

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MEnumeration;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.component.MAbstractButton;
import com.a2a.adjava.xmodele.ui.menu.MMenu;
import com.a2a.adjava.xmodele.ui.menu.MMenuActionItem;
import com.a2a.adjava.xmodele.ui.menu.MMenuItem;
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

public class LabelGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {
	
	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(LabelGenerator.class);
	
	/**
	 * Generated file
	 */
	//private static final String GENERATED_FILE_FIELD = "configDictionaryFieldsDefault";
	private static final String GENERATED_FILE_RESOURCE = "AppResources";
	private static final String GENERATED_FILE_RESOURCE_STORE = "Resources";
	
	/**
	 * Xsl file
	 */
	//private static final String XSL_FILE_FIELD = "fields-visual-property.xsl";
	private static final String XSL_FILE_RESOURCE = "resources-label.xsl";
	private static final String XSL_FILE_RESOURCE_CS = "resources-label-cs.xsl";
	
	//Map<String,Map<String,String>> mapfields = new HashMap<String,Map<String,String>>();
	Map<String,String> mapResource = new HashMap<String,String>();

	/**
	 * {@inheritDoc}
	 */
	public void genere(
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> LabelGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		for( Locale oLocale : this.getLocales()) {	
			//Element xFields = DocumentHelper.createElement("fields");
			Element xResources = DocumentHelper.createElement("labels");
			xResources.addElement("base-package").setText(p_oMProject.getDomain().getRootPackage());
			this.genLabelsForLayout(p_oMProject);
			this.genLabelsForScreen(p_oMProject);
			
			//this.buildDocFields(xFields, oLocale);
			this.buildDocResources(xResources, oLocale);
			
			//Document xInterfacesDocumentFields = DocumentHelper.createDocument(xFields);
			Document xInterfacesDocumentResources = DocumentHelper.createDocument(xResources);
			
			//String oTargetFileFields = this.getOutputFileFields(p_oMProject, oLocale);

			String oTargetFileResources = this.getOutputFileResourcesStore(p_oMProject, oLocale);
			this.doIncrementalTransform(XSL_FILE_RESOURCE, oTargetFileResources, xInterfacesDocumentResources, p_oMProject, p_oGeneratorContext);
				
			//this.doIncrementalTransform(XSL_FILE_FIELD, oTargetFileFields, xInterfacesDocumentFields, p_oMProject, p_oGeneratorContext);
		}

		log.debug("< LabelGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Generate labels for layout : fields end buttons
	 * @param p_mapLabels labels 
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void genLabelsForLayout(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) throws Exception {
		if (!p_oMProject.getDomain().getDictionnary().getAllLayouts().isEmpty()) {

			for (MLayout oLayout : p_oMProject.getDomain().getDictionnary().getAllLayouts()) {
				for (MVisualField oField : oLayout.getFields()) {
					if(oField.getLabel() != null){
						String propertyName;
						if(oField.getViewModelProperty().indexOf('.') != -1){
							propertyName = oField.getViewModelProperty().replace('.', '_');
						}
						else{
							propertyName = oField.getViewModelName() + oField.getViewModelProperty();
						}
						
						mapResource.put(propertyName, oField.getLabel().getKey());
					}
//					String key = oField.getViewModelName() + "Item." + oField.getViewModelProperty();
//					Map<String,String> fieldValues = new HashMap<String,String>();
//					fieldValues.put("IsCreateLabel", String.valueOf(oField.isCreateLabel()));
//					fieldValues.put("IsEnabled", String.valueOf(!oField.isReadOnly()));
//					fieldValues.put("IsMandatory", String.valueOf(oField.isMandatory()));
//					mapfields.put(key, fieldValues);
				}
				for(MAbstractButton oButton : oLayout.getButtons()) {
					if("phone".equals(p_oMProject.getName()))
					{
						mapResource.put(oButton.getName(), oButton.getLabelValue());
					}
					else
					{
						mapResource.put(oButton.getName()+".Content", oButton.getLabelValue());
					}
				}
				if (oLayout.getScreen() != null && oLayout.getScreen().get().getName() != null) {
					if("phone".equals(p_oMProject.getName()))
					{
						mapResource.put(oLayout.getScreen().get().getName(), oLayout.getScreen().get().getName());
					}
					else
					{
						mapResource.put(oLayout.getScreen().get().getName() + ".Text", oLayout.getScreen().get().getName());
					}
				}
			}
		}
	}
	
	/**
	 * Generate labels for layout : fields end buttons
	 * @param p_mapLabels labels 
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void genLabelsForScreen(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) throws Exception {
		if (!p_oMProject.getDomain().getDictionnary().getAllLayouts().isEmpty()) {
			for (MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
				if (oScreen.getName() != null) {
					if("phone".equals(p_oMProject.getName()))
					{
						mapResource.put(oScreen.getName(), oScreen.getName());
					}
					else
					{
						mapResource.put(oScreen.getName() + ".Text", oScreen.getName());
					}
				}
			}
		}
	}
	
	
	/**
	 * Generate labels for enumerations
	 * @param p_mapLabels labels 
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void genLabelsForEnumerations(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) throws Exception {
		if (!p_oMProject.getDomain().getDictionnary().getAllEnumerations().isEmpty()) {

			for (MEnumeration oEnum : p_oMProject.getDomain().getDictionnary().getAllEnumerations()) {
				for (String sToken : oEnum.getEnumValues()) {
					mapResource.put( StringUtils.join("enum_", oEnum.getName(), "_", sToken), sToken);
				}
			}
		}
	}

	/**
	 * @param p_xLabels
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void genLabelsForMenu(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) throws Exception {

		for (MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {

			for (MMenu oMenu : oScreen.getMenus()) {

				for (MMenuItem oMenuItem : oMenu.getMenuItems()) {
					StringBuilder sTitle = null;
					
					if (oMenuItem instanceof MMenuActionItem) {
						MMenuActionItem oMMenuActionItem = (MMenuActionItem) oMenuItem;
						sTitle = new StringBuilder("application_actionmenu_");
						sTitle.append(oScreen.getName().toLowerCase());
						if (!oMMenuActionItem.getActions().isEmpty()) {
							mapResource.put(sTitle.toString(), oMMenuActionItem.getActions().get(0).getName().toLowerCase());
						} else {
							sTitle.append("_"+oMMenuActionItem.getNavigationButton().getName().toLowerCase());
							mapResource.put(sTitle.toString(), oMMenuActionItem.getNavigationButton().getName().toLowerCase());
						}
					} else {
						
						sTitle = new StringBuilder("application_menu_");
						sTitle.append(oScreen.getName().toLowerCase());
						sTitle.append('_');
						sTitle.append(oMenu.getId());
						sTitle.append('_');
					
						sTitle.append(oMenuItem.getNavigation().getTarget().getName().toLowerCase());
						mapResource.put(sTitle.toString(), oMenuItem.getNavigation().getTarget().getName());
					}
					
				}
			}
			mapResource.put( oScreen.getName() ,oScreen.getName() ); 
		}
	}
	
	/**
	 * Build xml from map of visual properties of fields
	 * @param p_mapLabels map of visual properties of fields
	 * @param p_xVisualProperties xml output
	 * @param p_oLocale locale
	 */
//	private void buildDocFields(Element p_xVisualProperties, Locale p_oLocale) {
//		for( Entry<String,Map<String,String>> oEntry : mapfields.entrySet()) {
//			Map<String,String> fieldValues = oEntry.getValue();
//			Element xElField = p_xVisualProperties.addElement("field");
//			xElField.addAttribute("name", oEntry.getKey());
//			Element xElVisualProperties = xElField.addElement("visual-properties");
//			for( Entry<String,String> oEntry2 : fieldValues.entrySet()) {
//				Element xElVisualProperty = xElVisualProperties.addElement("visual-property");
//				xElVisualProperty.addAttribute("name", oEntry2.getKey());
//				xElVisualProperty.setText(oEntry2.getValue());
//			}
//		}
//	}
	
	/**
	 * Build xml from map of labels
	 * @param p_mapLabels map of labels
	 * @param p_xLabels xml output
	 * @param p_oLocale locale
	 */
	private void buildDocResources(Element p_xLabels, Locale p_oLocale) {
		for( Entry<String,String> oEntry : mapResource.entrySet()) {
			Element xEl = p_xLabels.addElement("label");
			xEl.addAttribute("name", oEntry.getKey());
			xEl.setText(oEntry.getValue());
		}
	}
	
	/**
	 * Return output file for xsl generation
	 * @param p_oProject project
	 * @return output file
	 */
//	protected String getOutputFileFields( XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oProject, Locale p_oLocale ) {
//		return FileTypeUtils.computeFilenameForXmlClass(p_oProject.getSourceDir() + "/Common",
//				GENERATED_FILE_FIELD);
//	}
	
	/**
	 * Return output file for xsl generation
	 * @param p_oProject project
	 * @return output file
	 */
	protected String getOutputFileResources( XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oProject, Locale p_oLocale ) {
		return FileTypeUtils.computeFilenameForResxClass(p_oProject.getSourceDir() + "/Resources",
				GENERATED_FILE_RESOURCE);
	}
	
	/**
	 * Return output file for xsl generation
	 * @param p_oProject project
	 * @return output file
	 */
	protected String getOutputFileResourcesStore( XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oProject, Locale p_oLocale ) {
		return FileTypeUtils.computeFilenameForReswClass(p_oProject.getSourceDir() + "/Resources",
				GENERATED_FILE_RESOURCE_STORE);
	}
	
	/**
	 * Return output file for xsl generation
	 * @param p_oProject project
	 * @return output file
	 */
	protected String getOutputFileResourcesCs( XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oProject, Locale p_oLocale ) {
		return FileTypeUtils.computeFilenameForCSharpImpl("Resources",
				GENERATED_FILE_RESOURCE + ".Designer",p_oProject.getSourceDir());
	}
	
	/**
	 * Return locales to generate labels for
	 * @return locales
	 */
	protected Locale[] getLocales() {
		return new Locale[] { Locale.FRENCH };
	}
}