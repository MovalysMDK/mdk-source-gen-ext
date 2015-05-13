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

import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.mupdater.MUpdater;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;

/**
 * <p>Permet d'initialiser les clés primaires des beans avec la valeur -1.</p>
 *
 * <p>Copyright (c) 2009<p>
 * <p>Company: Adeuza<p>
 *
 * @see AbstractUmlUpdater
 *
 * @since 2.5
 * @author mmadigand
 *
 */
public class InitializePrimaryKeyAttributeUpdater extends AbstractMUpdater {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(InitializePrimaryKeyAttributeUpdater.class);
	
	/**
	 * {@inheritDoc}
	 * @see MUpdater#execute(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.uml.UmlModele, java.util.Map)
	 */
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oXDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		log.debug("> InitializePrimaryKeyAttributeUpdater.execute()");
		
		IModelDictionary oModeleDictionnary = p_oXDomain.getDictionnary();
		
		for (MEntityImpl oMClass : oModeleDictionnary.getAllEntities() ) {
			for (MAttribute oMAttribute : oMClass.getIdentifier().getElemOfTypeAttribute()) {
				if("long".equals(oMAttribute.getTypeDesc().getUmlName())){
					oMAttribute.setInitialisation("-1");
				}
			}
		}
		
		log.debug("< InitializePrimaryKeyAttributeUpdater.execute()");
	}

}
