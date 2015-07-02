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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.generator;

import org.apache.commons.io.FilenameUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.override.AbstractOverrideGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.android.xmodele.MAndroidProject;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MDaoImpl;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * <p>
 * Generate SuperFactory of Dao
 * </p>
 * 
 * <p>
 * Copyright (c) 2011
 * <p>
 * Company: Adeuza
 * 
 * @author emalespine
 * 
 */

public class PojoPropertiesGenerator extends AbstractOverrideGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(PojoPropertiesGenerator.class);
	
	private static final String XSL_FILE_NAME = "properties.xsl";

	private static final String GENERATED_FILE = "beans_model";

	/**
	 * Génère l'interface SuperEntityFactory
	 */
	@Override
	public void genere( XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> PojoPropertiesGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> oAndroidProject = 
				(MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>>) p_oMProject;
		
		// At least an entity or a dataloader to create the file beans_model
		if ( !p_oMProject.getDomain().getDictionnary().getAllEntities().isEmpty() ||
				!p_oMProject.getDomain().getDictionnary().getAllDataLoaders().isEmpty()) {
			Element xRoot = DocumentHelper.createElement("root");

			Element xFactories	= xRoot.addElement("factories");
			Element xFactory	= null;
			for (MEntityImpl oEntity : p_oMProject.getDomain().getDictionnary().getAllEntities()) {
				xFactory = xFactories.addElement("factory");
				xFactory.addElement("interface").setText(oEntity.getFactoryInterface().getFullName());
				xFactory.addElement("implementation").setText(oEntity.getFactory().getFullName());
			}

			for (MEntityImpl oEntity : p_oMProject.getDomain().getDictionnary().getAllJoinClasses()) {
				xFactory = xFactories.addElement("factory");
				xFactory.addElement("interface").setText(oEntity.getFactoryInterface().getFullName());
				xFactory.addElement("implementation").setText(oEntity.getFactory().getFullName());
			}

			Element xDaos	= xRoot.addElement("daos");
			Element xDao	= null;
			for (MDaoImpl oDao : p_oMProject.getDomain().getDictionnary().getAllDaos()) {
				xDao = xDaos.addElement("dao");
				xDao.addElement("interface").setText(oDao.getMasterInterface().getFullName());
				xDao.addElement("implementation").setText(oDao.getMasterInterface().getFullName() + "Impl");
			}

			Element xLoaders	= xRoot.addElement("dataloaders");
			Element xLoader		= null;
			for (MDataLoader oLoader : p_oMProject.getDomain().getDictionnary().getAllDataLoaders()) {
				xLoader = xLoaders.addElement("dataloader");
				xLoader.addElement("interface").setText(oLoader.getMasterInterface().getFullName());
				xLoader.addElement("implementation").setText(oLoader.getFullName());
			}
			
			String sTargetFile = FilenameUtils.concat(oAndroidProject.getRawDirectory(), GENERATED_FILE);

			Document xInterfacesDocument = DocumentHelper.createDocument(xRoot);
			this.doOverrideTransform(XSL_FILE_NAME, sTargetFile, xInterfacesDocument, p_oMProject, p_oContext);
		}
		
		log.debug("< PojoPropertiesGenerator.genere: {}", oChrono.stopAndDisplay());
	}
}