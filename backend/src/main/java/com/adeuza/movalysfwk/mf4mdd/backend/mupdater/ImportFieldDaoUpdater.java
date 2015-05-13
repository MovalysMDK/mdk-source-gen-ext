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

import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.mupdater.MUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MDaoImpl;

/**
 * <p>
 * TODO Décrire la classe DaoCascadeUpdater
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

public class ImportFieldDaoUpdater extends AbstractMUpdater {
	/**
	 * Suffixe des énumérations des colonnes d'une table associée à une entité.
	 */
	private static final String ENUM_FIELD_SUFFIX = "Field";

	/**
	 * Ajoute l'import de la cascade associer à l'entité gérée par le DAO.
	 * 
	 * @see MUpdater#execute(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.uml.UmlModele, java.util.Map)
	 */
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oXDomain, Map<String, ?> p_oGlobalSession) throws Exception {

		for (MDaoImpl oMDao : p_oXDomain.getDictionnary().getAllDaos()) {
			StringBuilder sImport = new StringBuilder();
			sImport.append(oMDao.getMasterInterface().getFullName());
			sImport.append('.');
			sImport.append(oMDao.getMEntityImpl().getMasterInterface().getName());
			sImport.append(ENUM_FIELD_SUFFIX);
			oMDao.addImport(sImport.toString());

			// for (MAssociation oAssociation : oMDao.getMClass().getAssociations()) {
			// if (oAssociation.getAssociationType() == MAssociation.AssociationType.MANY_TO_MANY) {
			// // Il faut rajouter la dépendance vers l'énumération des fields de la classe d'asso au dao de l'autre entité mise en jeu
			// MJoinClass oJoinClass = ((MAssociationManyToMany) oAssociation).getJoinClass();
			// MDao oOppositeDao = oAssociation.getRefClass().getDao();
			// if (oMDao == oOppositeDao) {
			// oOppositeDao = oAssociation.getOppositeClass().getDao();
			// }
			//
			// oOppositeDao.addImport(new StringBuilder()
			// .append(oJoinClass.getDao().getMPackage().getFullName())
			// .append('.')
			// .append(oJoinClass.getImplementedInterface().getName())
			// .append(ENUM_FIELD_SUFFIX).toString());
			// }
			// }
		}
	}
}
