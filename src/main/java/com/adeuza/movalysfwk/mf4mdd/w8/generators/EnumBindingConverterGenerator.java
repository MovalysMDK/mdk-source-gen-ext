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

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.NonGeneratedBlocExtractor;
import com.a2a.adjava.generator.impl.ViewModelGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEnumeration;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XProject;
import com.sun.corba.se.spi.oa.OADefault;

/**
 * Enum data template generator for Win8
 * @author jcoudsi
 *
 */
public class EnumBindingConverterGenerator extends ViewModelGenerator {
	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(EnumBindingConverterGenerator.class);
	
	/**
	 * Xsl template for converter
	 */
	private static final String ENUMERATION_BINDING_CONVERTER_XSL = "enum-binding-converter.xsl";
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void genere(XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> EnumBindingConverterGenerator.genere");
		Chrono oChrono = new Chrono(true);
		NonGeneratedBlocExtractor oNonGeneratedBlocExtractor = new NonGeneratedBlocExtractor();
		
		for(MViewModelImpl oViewModel : p_oProject.getDomain().getDictionnary().getAllViewModels()) {
			
			if(!oViewModel.isScreenViewModel()) {
				
				//Recherche des énumérations utilisées dans le view model
				for (MAttribute oAttribute : oViewModel.getAttributes()) {
					
					//Pour chaque énumération trouvée, on génère le datatemplate correspondant
					if (oAttribute.isEnum()) {
						Document xAttribute = createDocument(oAttribute, p_oProject);
						this.createEnumerationBindingConverter(oViewModel, xAttribute, oAttribute.getTypeDesc().getShortName(), p_oProject, p_oContext);
					}
				}

			}
		}
		log.debug("< EnumBindingConverterGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * Génère le converter pour le binding d'une énumération utilisée dans un view model
	 * Nécessaire pour l'utilisation du composant MFRadioEnum
	 * 
	 * @param p_oViewModel
	 *            view model
	 * @param p_oNonGeneratedBlocExtractor
	 *            les blocs non generes
	 * @param p_oProjectConfig
	 *            config adjava
	 * @param p_oXslEnumTransformer
	 *            transformer xsl
	 * @throws Exception
	 *             Echec de generation
	 */
	private void createEnumerationBindingConverter(MViewModelImpl p_oViewModel, Document p_xAttribute, String enumName, XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {

			String sEnumConverterFile = FileTypeUtils.computeFilenameForCSharpImpl(
					"ViewModel.Converters", enumName + "EnumToBooleanValueConverter", p_oProject.getSourceDir());
			
			this.doIncrementalTransform(ENUMERATION_BINDING_CONVERTER_XSL, sEnumConverterFile, p_xAttribute, p_oProject, p_oContext);
	}
	
	
	/**
	 * Create document
	 * @param p_oAttribute attribute
	 * @param p_oProject project
	 * @return xml of attribute implementation
	 */
	protected Document createDocument(MAttribute p_oAttribute,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oProject) {

		Element r_xAttributeFile = p_oAttribute.toXml();
		//On rajoute le nom  complet du package du projet view model
		r_xAttributeFile.addElement("package").setText(p_oProject.getDomain().getDictionnary().getViewModelCreator().getPackage().getFullName());
		
		//Parcours des énumérations 
		for (MEnumeration oEnumeration : p_oProject.getDomain().getDictionnary().getAllEnumerations()) {
			//Pour l'énumération en cours de traitement, on rajoute le nom complet de son package
			if (oEnumeration.getTypeDescription().getShortName() == p_oAttribute.getTypeDesc().getShortName())
			{
				r_xAttributeFile.addElement("package-enum").setText(oEnumeration.getPackage().getFullName());
			}
		}
		
		return DocumentHelper.createDocument(r_xAttributeFile);
	}
	
}
