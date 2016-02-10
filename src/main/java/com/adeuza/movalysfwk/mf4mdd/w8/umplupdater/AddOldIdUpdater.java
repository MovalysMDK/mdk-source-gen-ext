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
package com.adeuza.movalysfwk.mf4mdd.w8.umplupdater;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.mupdater.MUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAnnotation;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;

/**
 * Ajoute un attribut oldId sur les entités persistables pour contenir l'ancienne valeur de la clé primaire.
 * Cet updater ne fonctionne pour le moment qu'avec les entités ayant une clé primaire simple. 
 * @author lmichenaud
 *
 */
public class AddOldIdUpdater extends AbstractMUpdater {

	public static final MAnnotation unexposedAnnotation 
		= new MAnnotation("Unexposed", "com.adeuza.movalysfwk.mobile.mf4mjcommons.rest.json.gson.Unexposed");
	
	/**
	 *  
	 * @see MUpdater#execute(com.a2a.adjava.project.ProjectConfig,
	 *      com.a2a.adjava.uml.UmlModele, java.util.Map)
	 */
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {

		boolean bTranscient = true;

		for (MEntityImpl oEntityImpl : p_oDomain.getDictionnary().getAllEntities()) {
			// Pour le moment, on ne gere que les entités ayant une clé simple
			// de type attribut
			if (!oEntityImpl.isTransient() && !oEntityImpl.getIdentifier().isComposite()
					&& oEntityImpl.getIdentifier().getElemOfTypeAttribute().size() == 1) {

				MAttribute oAttr = oEntityImpl.getIdentifier().getElemOfTypeAttribute().get(0);

				String sAttrName = "old" + StringUtils.capitalize(oAttr.getName());

				MAttribute oNewAttr = p_oDomain.getXModeleFactory().createMAttribute(sAttrName, "private",
						false, false, bTranscient, oAttr.getTypeDesc(), oAttr.getDocumentation());
				oNewAttr.setInitialisation(oAttr.getInitialisation());
				oNewAttr.addParameter("oldidholder", "true");
				
				oEntityImpl.addAttribute(oNewAttr);
				
				oEntityImpl.addParameter("oldidholder", "true");
								
				oNewAttr.addAnnotation(unexposedAnnotation);
				oEntityImpl.addImport(unexposedAnnotation.getFullName());
			}
		}
	}
}
