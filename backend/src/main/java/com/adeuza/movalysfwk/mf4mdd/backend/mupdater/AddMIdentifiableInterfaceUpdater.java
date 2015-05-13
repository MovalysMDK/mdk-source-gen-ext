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
package com.adeuza.movalysfwk.mf4mdd.backend.mupdater;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.messages.MessageHandler;
import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.mupdater.MUpdater;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MLinkedInterface;
import com.a2a.adjava.xmodele.MStereotype;

/**
 * <p>
 * Permet d'ajouter l'interface MIdentifiable au entités qui possède un
 * attribut id de type long et qui est à lui seul la clé primaire de l'entité.
 * </p>
 * 
 * <p>
 * Copyright (c) 2009
 * <p>
 * <p>
 * Company: Adeuza
 * <p>
 * 
 * @see AbstractUmlUpdater
 * 
 * @since 2.5
 * @author mmadigand
 * 
 */
public class AddMIdentifiableInterfaceUpdater extends AbstractMUpdater {

	/**
	 * TODO Décrire le champs AddMIdentifiableInterfaceUpdater.java
	 */
	public static final String IDENTIFIABLE_INTERFACE_NAME = "IdentifiableBOEntity";

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(AddMIdentifiableInterfaceUpdater.class);

	/**
	 * {@inheritDoc}
	 * @see MUpdater#execute(com.a2a.adjava.project.ProjectConfig,
	 *      com.a2a.adjava.uml.UmlModele, java.util.Map)
	 */
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oXDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		log.debug("> AddMIdentifiableInterfaceUpdater.execute()");

		IModelDictionary oModeleDictionnary = p_oXDomain.getDictionnary();

		for (MEntityImpl oMClass : oModeleDictionnary.getAllEntities()) {
			List<MStereotype> oStereoTypeList = oMClass.getStereotypes();
			if (!oStereoTypeList.isEmpty()) {
				String sStereotypeName = null;
				for (MStereotype oMStereotype : oStereoTypeList) {
					sStereotypeName = oMStereotype.getName();
					if ("InterfaceIdentifiableMEntity".equalsIgnoreCase(sStereotypeName)) {
						MessageHandler.getInstance().addError(
								"Veuillez ne pas indiquer le stéréotype 'InterfaceIdentifiableMEntity' sur la classe "
										+ oMClass.getName());
					}
				}
			}
			if (!oMClass.getIdentifier().isComposite()
					&& !oMClass.isTransient()
					&& "id".equalsIgnoreCase(oMClass.getIdentifier().getElems().get(0).getName())) {
				MAttribute oMAttribute = oMClass.getIdentifier().getElemOfTypeAttribute().get(0);
				if ("long".equalsIgnoreCase(oMAttribute.getTypeDesc().getName())) {
					oMClass.getMasterInterface().addLinkedInterface(
							new MLinkedInterface(IDENTIFIABLE_INTERFACE_NAME, this.getParametersMap().get(
									IDENTIFIABLE_INTERFACE_NAME)));
				}
			}
		}

		log.debug("< AddMIdentifiableInterfaceUpdater.execute()");
	}

}
