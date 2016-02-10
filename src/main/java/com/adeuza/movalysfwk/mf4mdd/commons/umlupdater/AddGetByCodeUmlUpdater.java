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
package com.adeuza.movalysfwk.mf4mdd.commons.umlupdater;

import java.util.Collection;
import java.util.Map;

import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlDictionary;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml.UmlOperation;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;

/**
 * <p>Ajoute les opérations de récupération par code si elles n'existent pas</p>
 * <p>Copyright (c) 2009
 * <p>Company: Adeuza
 *
 * @author lmichenaud
 *
 */

public class AddGetByCodeUmlUpdater extends AbstractUmlUpdater {

	/**
	 * TODO Décrire le champs AddGetByCodeUmlUpdater.java 
	 */
	private static final String CRITERIA_CODE = "_By_Code";

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.umlupdater.UmlUpdater#execute(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.uml.UmlModel, java.util.Map)
	 */
	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession) throws Exception {
		
		UmlDictionary oUmlDictionnary = p_oUmlModele.getDictionnary();
		this.addGetByCodeMethods(oUmlDictionnary.getAllClasses());
		this.addGetByCodeMethods(oUmlDictionnary.getAssociationClasses());
		
	}
	
	/**
	 * TODO Décrire la méthode addGetByCodeMethods de la classe AddGetByCodeUmlUpdater
	 * @param p_listUmlClass
	 */
	private void addGetByCodeMethods( Collection<? extends UmlClass> p_listUmlClass ) {
		for (UmlClass oUmlClass : p_listUmlClass ) {
			if ( oUmlClass.hasAttribute("code")) {
				String sGetByCodeOperationName = "get" + oUmlClass.getName() + CRITERIA_CODE;
				if ( !oUmlClass.hasOperation(sGetByCodeOperationName)) {
					oUmlClass.addOperation( new UmlOperation(sGetByCodeOperationName, oUmlClass));
				}
				String sGetListOperationName = "getVecteur" + oUmlClass.getName() + CRITERIA_CODE;
				String sGetListOperationName2 = "getList" + oUmlClass.getName() + CRITERIA_CODE;
				if ( !oUmlClass.hasOperation(sGetListOperationName) && !oUmlClass.hasOperation(sGetListOperationName2 )) {
					oUmlClass.addOperation( new UmlOperation(sGetListOperationName2, oUmlClass));
				}
			}
		}		
	}
}
