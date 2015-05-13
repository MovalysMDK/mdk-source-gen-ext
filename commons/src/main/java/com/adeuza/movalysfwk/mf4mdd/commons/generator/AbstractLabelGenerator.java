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
package com.adeuza.movalysfwk.mf4mdd.commons.generator;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.XslTemplate;
import com.a2a.adjava.generator.core.xmlmerge.AbstractXmlMergeGenerator;
import com.a2a.adjava.generator.core.xmlmerge.xa.configuration.XaConfFile;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MLabel;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;

/**
 * Abstract label generator
 * @author lmichenaud
 *
 */
public abstract class AbstractLabelGenerator<MFD extends MFDomain<? extends MFModelDictionary, ? extends MFModelFactory>> extends AbstractXmlMergeGenerator<MFD> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(AbstractLabelGenerator.class);
	

	/**
	 * Return output file for xsl generation
	 * @param p_oProject project
	 * @return output file
	 */
	protected abstract File getOutputFile( XProject<MFD> p_oProject, Locale p_oLocale );
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	public void genere(XProject<MFD> p_oProject, DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> LabelGenerator.genere");
		Chrono oChrono = new Chrono(true);

		for( Locale oLocale : this.getLocales()) {
		
			Element xLabels = DocumentHelper.createElement("labels");
	
			Map<String,MLabel> mapLabels = new HashMap<>();
			
			this.genLabels(mapLabels, p_oProject, oLocale);
			this.buildDoc(mapLabels, xLabels, oLocale);
	
			File oTargetFile = this.getOutputFile(p_oProject, oLocale);
	
			Document xInterfacesDocument = DocumentHelper.createDocument(xLabels);
			//this.doAppendGeneration(xInterfacesDocument, this.getXslTemplate(oLocale), oTargetFile, p_oProject, p_oContext);
			this.doXmlMergeGeneration(xInterfacesDocument, this.getXslTemplate(oLocale), oTargetFile, p_oProject, p_oContext,XaConfFile.LABEL);
		}
		
		log.debug("< LabelGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * Generate labels
	 * @param p_mapLabels label container
	 * @param p_oMProject project
	 * @param p_oLocale locale
	 * @throws Exception exception
	 */
	protected void genLabels(Map<String,MLabel> p_mapLabels, XProject<MFD> p_oMProject, Locale p_oLocale) throws Exception {
		this.genLabelsFromDictionary(p_mapLabels, p_oMProject);
	}
	
	/**
	 * Gen label from labels of dictionary
	 * @param p_mapLabels map of labels
	 * @param p_oMProject project
	 */
	protected void genLabelsFromDictionary(Map<String,MLabel> p_mapLabels, XProject<MFD> p_oMProject) {
		p_mapLabels.putAll(p_oMProject.getDomain().getDictionnary().getLabelMap());
	}
	
	/**
	 * Build xml from map of labels
	 * @param p_mapLabels map of labels
	 * @param p_xLabels xml output
	 * @param p_oLocale locale
	 */
	private void buildDoc(Map<String,MLabel> p_mapLabels, Element p_xLabels, Locale p_oLocale) {
		for( MLabel oEntry : p_mapLabels.values()) {
			Element xEl = p_xLabels.addElement("label");
			xEl.addAttribute("name", oEntry.getKey());
			xEl.setText(oEntry.getValue());
		}
	}
	
	/**
	 * Return xsl template
	 * @param p_oLocale locale
	 * @return xsl template
	 */
	protected XslTemplate getXslTemplate( Locale p_oLocale ) {
		return XslTemplate.LABEL;
	}
	
	/**
	 * Return locales to generate labels for
	 * @return locales
	 */
	protected Locale[] getLocales() {
		return new Locale[] { Locale.FRENCH };
	}
}
