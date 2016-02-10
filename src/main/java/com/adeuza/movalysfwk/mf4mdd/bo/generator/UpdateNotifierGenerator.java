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
package com.adeuza.movalysfwk.mf4mdd.bo.generator;

import java.util.ArrayList;
import java.util.List;

import javax.xml.transform.TransformerException;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MAssociation.AssociationType;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.ModelDictionary;
import com.a2a.adjava.xmodele.XDomain;
import com.a2a.adjava.xmodele.XModeleFactory;
import com.a2a.adjava.xmodele.XProject;

/**
 * <p>
 * Crée les classes UpdateNotifier
 * </p>
 * 
 * <p>
 * Copyright (c) 2009
 * <p>
 * Company: Adeuza
 * 
 * @author lmichenaud
 * 
 */

public class UpdateNotifierGenerator extends AbstractIncrementalGenerator<XDomain<ModelDictionary,XModeleFactory>> {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(UpdateNotifierGenerator.class);

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.generator.ResourceGenerator#genere(com.a2a.adjava.project.ProjectConfig,
	 *      com.a2a.adjava.xmodele.MModele, com.a2a.adjava.schema.Schema,
	 *      java.util.Map)
	 */
	@Override
	public void genere(XProject<XDomain<ModelDictionary,XModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> UpdateNotifierGenerator.genere");

		IModelDictionary oDictionnary = p_oMProject.getDomain().getDictionnary();

		for (MEntityImpl oClass : oDictionnary.getAllEntities()) {
			createUpdateNotifier(oClass, p_oMProject, p_oContext);
		}
		log.debug("< UpdateNotifierGenerator.genere");
	}

	/**
	 * @param p_oClass
	 * @throws TransformerException
	 */
	private void createUpdateNotifier(MEntityImpl p_oClass, XProject<XDomain<ModelDictionary,XModeleFactory>> p_oProject,
			DomainGeneratorContext p_oContext) throws Exception {

		List<MAssociation> listAssociations = new ArrayList<MAssociation>();
		listAssociations.addAll(p_oClass.getAssociations());
		listAssociations.addAll(p_oClass.getIdentifier().getElemOfTypeAssociation());

		for (MAssociation oAssociation : listAssociations) {
			if (oAssociation.getAssociationType() == AssociationType.MANY_TO_ONE
					|| oAssociation.getAssociationType() == AssociationType.ONE_TO_ONE) {
				p_oClass.addImport(oAssociation.getTypeDesc().getName() + "UpdateNotifier");
			} else {
				p_oClass.addImport(oAssociation.getTypeDesc().getParameterizedElementType().get(0).getName()
						+ "UpdateNotifier");
			}
		}

		Document xClass = DocumentHelper.createDocument(p_oClass.toXml());

		String sUpdateNotifierFile = p_oProject.getSourceDir() + "/"
				+ p_oClass.getMasterInterface().getFullName().replace('.', '/') + "UpdateNotifier.java";

		log.debug("génération du fichier " + sUpdateNotifierFile);
		this.doIncrementalTransform("updatenotifier.xsl", sUpdateNotifierFile, xClass, p_oProject,
				p_oContext);
	}
}
