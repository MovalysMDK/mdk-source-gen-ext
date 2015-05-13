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

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.mupdater.MUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MIdentifierElem;
import com.a2a.adjava.xmodele.MLinkedInterface;

/**
 * <p>
 * Permet d'ajouter l'interface MCodableEntity sur les entity ayant l'attribut code
 * </p>
 * 
 * <p>
 * Copyright (c) 2009
 * <p>
 * <p>
 * Company: Adeuza
 * <p>
 * 
 * @see AbstractMUpdater
 * 
 * @since 2.5
 * @author lmichenaud
 * 
 */
public class AddMCodableInterfaceUpdater extends AbstractMUpdater {

	/**
	 * Codable interface parameter
	 */
	private static final String CODABLE_INTERFACE_PARAMETER = "codableInterface";
	
	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(AddMCodableInterfaceUpdater.class);

	/**
	 * {@inheritDoc}
	 * @see MUpdater#execute(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.uml.UmlModele, java.util.Map)
	 */
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oXDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		log.debug("> AddMCodableInterfaceUpdater.execute()");

		IModelDictionary oModeleDictionnary = p_oXDomain.getDictionnary();

		String sCodableFullName = this.getParametersMap().get(CODABLE_INTERFACE_PARAMETER);
		String sCodableShortName = sCodableFullName.substring(sCodableFullName.lastIndexOf('.') + 1);
		
		// La classe doit contenir l'attribut code et doit etre de type String
		for (MEntityImpl oMClass : oModeleDictionnary.getAllEntities()) {
			MAttribute oAttr = oMClass.getAttributeByName("code", false);
			if ( oAttr == null ) {
				MIdentifierElem oElem = oMClass.getIdentifier().getElemByName("code", false);
				if ( oElem != null && MAttribute.class.isAssignableFrom(oElem.getClass())) {
					oAttr = (MAttribute) oElem ;
				}
			}
			if ( oAttr != null && oAttr.getTypeDesc().getShortName().equals("String")) {
				oMClass.getMasterInterface().addLinkedInterface(
						new MLinkedInterface(sCodableShortName, sCodableFullName));
			}
		}

		log.debug("< AddMCodableInterfaceUpdater.execute()");
	}
}
