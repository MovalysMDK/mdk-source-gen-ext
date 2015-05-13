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
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MLinkedInterface;

/**
 * <p>
 * Permet d'initialiser les clés primaires des beans avec la valeur -1.
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
public class AddMAdmAbleInterfaceUpdater extends AbstractMUpdater {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(AddMAdmAbleInterfaceUpdater.class);

	/**
	 * {@inheritDoc}
	 * 
	 * @see MUpdater#execute(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.uml.UmlModele, java.util.Map)
	 */
	//@Override
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oXDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		log.debug("> AddMAdmAbleInterfaceUpdater.execute()");

		IModelDictionary oModeleDictionnary = p_oXDomain.getDictionnary();

		for (MEntityImpl oMClass : oModeleDictionnary.getAllEntities()) {
			boolean bHaveAdmCreationKeyAttribute = false;
			boolean bHaveAdmLastModificationDateAttribute = false;
			boolean bHaveAdmLastModificationUserAttribute = false;
			boolean bHaveAdmLivingRecordAttribute = false;
			boolean bHaveAdmVersionAttribute = false;
			boolean bHaveAdmTrackingAttribute = false;

			String sAttributeName = null;
			for (MAttribute oMAttribute : oMClass.getAttributes()) {
				sAttributeName = oMAttribute.getName();
				if ("admCreationKey".equalsIgnoreCase(sAttributeName)) {
					bHaveAdmCreationKeyAttribute = true;
					oMAttribute.setName("admCreationKey");
				} else if ("admLastModificationDate".equalsIgnoreCase(sAttributeName)) {
					bHaveAdmLastModificationDateAttribute = true;
					oMAttribute.setName("admLastModificationDate");
				} else if ("admLastModificationUser".equalsIgnoreCase(sAttributeName)) {
					bHaveAdmLastModificationUserAttribute = true;
					oMAttribute.setName("admLastModificationUser");
				} else if ("admLivingRecord".equalsIgnoreCase(sAttributeName)) {
					bHaveAdmLivingRecordAttribute = true;
					oMAttribute.setName("admLivingRecord");
				} else if ("admVersion".equalsIgnoreCase(sAttributeName)) {
					bHaveAdmVersionAttribute = true;
					oMAttribute.setName("admVersion");
				} else if ("admTracking".equalsIgnoreCase(sAttributeName)) {
					bHaveAdmTrackingAttribute = true;
					oMAttribute.setName("admTracking");
				}
			}

			if (bHaveAdmCreationKeyAttribute && bHaveAdmLastModificationDateAttribute && bHaveAdmLastModificationUserAttribute
					&& bHaveAdmLivingRecordAttribute && bHaveAdmVersionAttribute && bHaveAdmTrackingAttribute) {
				log.trace(" oMClass.getName() = " + oMClass.getName());
				oMClass.getMasterInterface().addLinkedInterface(
						new MLinkedInterface("MAdmAble", this.getParametersMap().get("MAdmAble")));
			}
		}

		log.debug("< AddMAdmAbleInterfaceUpdater.execute()");
	}
}
