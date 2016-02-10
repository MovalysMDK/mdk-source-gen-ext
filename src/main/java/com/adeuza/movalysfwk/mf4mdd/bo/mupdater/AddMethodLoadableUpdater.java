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
package com.adeuza.movalysfwk.mf4mdd.bo.mupdater;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.AdjavaException;
import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MDaoImpl;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MLinkedInterface;
import com.adeuza.movalysfwk.mf4mdd.bo.generator.LoadMethodGenerator;

/**
 * <p>
 * Ajoute l'interface MethodLoadableUpdater sur les classes ayant l'interface
 * IdentifiableBOEntity
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

public class AddMethodLoadableUpdater extends AbstractMUpdater {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(AddMethodLoadableUpdater.class);

	/**
	 * Nom de l'interface MethodLoadable
	 */
	public static final String METHODLOADABLE_INTERFACE_NAME = "MethodLoadable";

	/**
	 * Nom de l'interface LoadMethod
	 */
	public static final String LOADMETHOD_INTERFACE_NAME = "LoadMethod";

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.mupdater.MUpdater#execute(com.a2a.adjava.project.ProjectConfig,
	 *      com.a2a.adjava.xmodele.MModele, java.util.Map)
	 */
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oXDomain, Map<String, ?> p_oGlobalSession) throws Exception {

		log.debug("> AddMethodLoadableUpdater.execute()");

		String sInterfaceFullName = this.getParametersMap().get(METHODLOADABLE_INTERFACE_NAME);
		if (sInterfaceFullName == null) {
			throw new AdjavaException("Impossible de trouver le paramètre : {}", METHODLOADABLE_INTERFACE_NAME);
		}

		String sLoadMethodFullName = this.getParametersMap().get(LOADMETHOD_INTERFACE_NAME);
		if (sLoadMethodFullName == null) {
			throw new AdjavaException("Impossible de trouver le paramètre : {}", LOADMETHOD_INTERFACE_NAME);
		}

		IModelDictionary oModeleDictionnary = p_oXDomain.getDictionnary();
		for (MEntityImpl oMClass : oModeleDictionnary.getAllEntities()) {
			if (oMClass.getMasterInterface().hasLinkedInterface(
					AddMIdentifiableInterfaceUpdater.IDENTIFIABLE_INTERFACE_NAME)) {
				oMClass.getMasterInterface().addLinkedInterface(
						new MLinkedInterface(METHODLOADABLE_INTERFACE_NAME, sInterfaceFullName));
			}
		}

		// Parcours des Dao pour rajouter les imports des LoadMethodEntity
		for (MDaoImpl oDao : oModeleDictionnary.getAllDaos()) {
			if (oDao.getMEntityImpl().getMasterInterface().hasLinkedInterface(METHODLOADABLE_INTERFACE_NAME)) {
				oDao.addImport(LoadMethodGenerator.getLoadMethodClassName(oDao.getMEntityImpl()
						.getMasterInterface()));
			}
			for (MAssociation oAssociation : oDao.getMEntityImpl().getAssociations()) {
				if (oAssociation.getRefClass().getMasterInterface()
						.hasLinkedInterface(METHODLOADABLE_INTERFACE_NAME)) {
					oDao.addImport(LoadMethodGenerator.getLoadMethodClassName(oAssociation.getRefClass()
							.getMasterInterface()));
				}
			}
			for (MAssociation oAssociation : oDao.getMEntityImpl().getIdentifier().getElemOfTypeAssociation()) {
				if (oAssociation.getRefClass().getMasterInterface()
						.hasLinkedInterface(METHODLOADABLE_INTERFACE_NAME)) {
					oDao.addImport(LoadMethodGenerator.getLoadMethodClassName(oAssociation.getRefClass()
							.getMasterInterface()));
				}
			}
		}

		log.debug("< AddMethodLoadableUpdater.execute()");
	}
}
