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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.mupdater;

import java.util.Map;

import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.mupdater.MUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MAssociationPersistableManyToMany;
import com.a2a.adjava.xmodele.MDaoImpl;
import com.a2a.adjava.xmodele.MJoinEntityImpl;

/**
 * <p>
 * ImportCascadeAndFieldDaoUpdater
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

public class ImportCascadeAndFieldDaoUpdater extends AbstractMUpdater {
	/**
	 * Suffixe des énumérations des colonnes d'une table associée à une entité.
	 */
	private static final String ENUM_FIELD_SUFFIX = "Field";

	/**
	 * Suffixe des énumérations représentant les cascades associées à une entité.
	 */
	private static final String ENUM_CASCADE_SUFFIX = "Cascade";

	/**
	 * Ajoute l'import de la cascade associer à l'entité gérée par le DAO.
	 * 
	 * @see MUpdater#execute(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.uml.UmlModele, java.util.Map)
	 */
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {

		MJoinEntityImpl oJoinClass = null;
		MDaoImpl oOppositeDao = null;
		for (MDaoImpl oMDao : p_oDomain.getDictionnary().getAllDaos()) {
			if (oMDao.getMEntityImpl().getAssociations().size() > 0) {
				oMDao.addImport(oMDao.getMEntityImpl().getMasterInterface().getFullName().concat(ENUM_CASCADE_SUFFIX));
			}
			oMDao.addImport(new StringBuilder().append(oMDao.getPackage().getFullName()).append('.')
					.append(oMDao.getMEntityImpl().getMasterInterface().getName()).append(ENUM_FIELD_SUFFIX).toString());

			for (MAssociation oAssociation : oMDao.getMEntityImpl().getAssociations()) {
				if (oAssociation.getAssociationType() == MAssociation.AssociationType.MANY_TO_MANY
					&& !oAssociation.isTransient()) {
					// Il faut rajouter la dépendance vers l'énumération des fields de la classe d'asso au dao de l'autre entité mise en jeu
					oJoinClass = ((MAssociationPersistableManyToMany) oAssociation).getJoinClass();
					oOppositeDao = oAssociation.getRefClass().getDao();
					if (oMDao == oOppositeDao) {
						oOppositeDao = oAssociation.getOppositeClass().getDao();
					}

					oOppositeDao.addImport(new StringBuilder().append(oJoinClass.getDao().getPackage().getFullName()).append('.')
							.append(oJoinClass.getMasterInterface().getName()).append(ENUM_FIELD_SUFFIX).toString());
				}
			}
			
			for( MAssociation oAsso: oMDao.getDeleteCascade()) {
				oMDao.addImport(oAsso.getOppositeClass().getMasterInterface().getFullName().concat(ENUM_CASCADE_SUFFIX));
			}
		}
	}
}
