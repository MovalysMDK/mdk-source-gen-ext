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
package com.adeuza.movalysfwk.mf4mdd.ios;

import java.util.Map;

import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;

/**
 * 
 * <p>Copyright (c) 2014</p>
 * <p>Company: Sopra</p>
 * 
 * Ajoute le caractère optionnel sur les attributs transients.
 * Cette modification est nécessaire sur iOS afin de pouvoir charger des données
 * initiales : les attributs transients n'étant pas renseignés dans les fichiers CSV,
 * il faut que ces attributs soient optionnels pour ne pas faire crasher l'application
 * à la sauvegarde des entités créées au tout premier lancement de l'application.
 * 
 * @see AbstractMUpdater
 * 
 * @since 4.0.11
 * @author qlagarde
 */

public class AddOptionalOnTransientAttributesUpdater extends AbstractMUpdater{

	@Override
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oDomain,
			Map<String, ?> p_oGlobalSession) throws Exception {
		IModelDictionary oDictionary = p_oDomain.getDictionnary();
		
		// Parcours de l'ensemble des entités
		for(MEntityImpl oEntity : oDictionary.getAllEntities()) {
			
			//Pour chaque entité, parcourt de l'ensemble de ses attributs
			for(MAttribute oAttribute : oEntity.getAttributes()) {
				//Si l'attribut est transient, on le définit comme optionnel
				if(oAttribute.isTransient()) {
					oAttribute.setMandatory(false);
				}
			}
		}
		
	}

}
